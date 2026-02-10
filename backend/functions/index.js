const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const admin = require("firebase-admin");
const { OpenAI } = require("openai");
// const pluralize = require("pluralize");
const { enforceRateLimit } = require("./rateLimiter");

// dictionary import removed as we now use LLM knowledge + API for symbols


// Language normalization map (Global)
const LANG_NORMALIZE_MAP = {
    'tr': 'Turkish', 'turkish': 'Turkish', 'türkçe': 'Turkish',
    'en': 'English', 'english': 'English',
    'es': 'Spanish', 'spanish': 'Spanish', 'español': 'Spanish',
    'de': 'German', 'german': 'German', 'deutsch': 'German',
    'pt': 'Portuguese', 'portuguese': 'Portuguese',
    'nl': 'Dutch', 'dutch': 'Dutch',
    'it': 'Italian', 'italian': 'Italian',
    'ru': 'Russian', 'russian': 'Russian',
    'fr': 'French', 'french': 'French'
};

// Initialize Firebase Admin (Required for Storage/Firestore access)
admin.initializeApp();

// Güvenli API Key - Firebase Secrets ile saklanır
// Deploy öncesi: firebase functions:secrets:set OPENAI_API_KEY
const openaiApiKey = defineSecret("OPENAI_API_KEY");

exports.interpretDream = onCall({ secrets: [openaiApiKey] }, async (request) => {
    // Rate limit check
    await enforceRateLimit('interpretDream', request);

    const openai = new OpenAI({ apiKey: openaiApiKey.value() });
    const { dreamText, mood, language } = request.data;

    if (!dreamText) {
        throw new HttpsError('invalid-argument', 'Missing dreamText');
    }


    try {
        // --- PASS 1: KEYWORD EXTRACTION & LANGUAGE DETECTION (Combined) ---
        // Goal: Normalize ANY language to English Context, Extract Symbols, and Detect Language in ONE pass.
        const extractionPrompt = `
        You are an expert dream symbol extractor and linguist.
        
        TASK:
        1. Read the user's dream text.
        2. DETECT the language of the dream (Output as 'detected_language').
        3. EXTRACT 2-4 dominant symbols. ONLY extract concrete objects, beings, places, or natural elements. Do NOT extract actions (chase, cry) or emotions (fear, joy).
        4. **CRITICAL**: ALL symbols MUST be in **ENGLISH**. Translate every symbol to its English equivalent. NEVER output symbols in the dream's original language.
        5. **SINGLE WORD ONLY**: Each symbol must be exactly ONE word. No adjectives, no colors, no compounds.
        
        WRONG: "ÖĞRENCİ", "AT", "EV", "BAHÇE", "YEMEK", "ZÜRAFA", "BLACK HORSE", "BIG SNAKE"
        CORRECT: "STUDENT", "HORSE", "HOME", "GARDEN", "FOOD", "GIRAFFE", "HORSE", "SNAKE"
        
        Examples:
        Input: "Rüyamda koca bir yılanın beni kovaladığını gördüm."
        Output: { "detected_language": "Turkish", "symbols": ["SNAKE"] }
        
        Input: "Rüyamda bir at bahçede duruyordu ve öğrencim eve geldi."
        Output: { "detected_language": "Turkish", "symbols": ["HORSE", "GARDEN", "STUDENT"] }
        
        Input: "A baby was crying and then an angel appeared near the ocean."
        Output: { "detected_language": "English", "symbols": ["BABY", "ANGEL", "OCEAN"] }
        
        OUTPUT FORMAT (JSON ONLY):
        {
          "detected_language": "Standard English Name (e.g., Turkish, English, Spanish)",
          "symbols": ["SYMBOL1", "SYMBOL2"]
        }
        `;

        const extractionCompletion = await openai.chat.completions.create({
            model: "gpt-4o-mini",
            messages: [
                { role: "system", content: extractionPrompt },
                { role: "user", content: `Dream Text: ${dreamText}` }
            ],
            response_format: { type: "json_object" },
            temperature: 0.1,
        });

        let keywords = [];
        let detectedLanguage = "English"; // Default

        // Use global LANG_NORMALIZE_MAP for normalization

        try {
            const raw = JSON.parse(extractionCompletion.choices[0].message.content);

            // Extract & Normalize Language
            if (raw.detected_language) {
                const rawLang = raw.detected_language.toLowerCase().trim();
                // Check global map, fallback to Capitalized Raw
                detectedLanguage = LANG_NORMALIZE_MAP[rawLang] || (rawLang.charAt(0).toUpperCase() + rawLang.slice(1));
                console.log("Detected dream language (merged pass):", detectedLanguage);
            }

            // Extract Keywords
            if (Array.isArray(raw.symbols)) {
                keywords = raw.symbols;
            } else if (Array.isArray(raw)) {
                keywords = raw;
            } else {
                keywords = raw.keywords || [];
            }
            if (!Array.isArray(keywords)) keywords = [];

            // Ensure Uppercase & Unique
            keywords = [...new Set(keywords.map(k => k.toUpperCase()))];

        } catch (e) {
            console.warn("Extraction/Detection failed", e);
        }

        // (Keyword injection removed - prompt handles English extraction)

        console.log("Extracted Keywords:", keywords);

        // --- PASS 2: JOURNAL API LOOKUP ---
        // Fetch meanings from Dreamboat Journal API
        const apiBase = "https://dreamboatjournal.com/api/meaning";
        let contextBuffer = [];
        let cosmicAnalysisBuffer = [];

        // Fetch in parallel
        const fetchPromises = keywords.map(async (key) => {
            try {
                const cleanKey = key.toLowerCase().trim();
                const finalKey = cleanKey;

                const response = await fetch(`${apiBase}/${finalKey}`);
                console.log(`API Fetch for '${finalKey}': status=${response.status}`);
                if (!response.ok) return null;

                const data = await response.json();
                // Return BOTH data and the finalKey used to fetch it
                return { data, finalKey };

            } catch (err) {
                console.error(`API Fetch Error for ${key}:`, err);
                return null;
            }
        });

        const results = await Promise.all(fetchPromises);

        results.forEach((result) => {
            if (result && result.data) {
                const { data, finalKey } = result;

                // Construct Jungian Reference Data Block
                // API Response Fields: introduction (short), symbolism (deep), cosmicAnalysis (moon)
                // {SEM_GIRIS}: Short encyclopedic definition (from 'introduction')
                // {SEM_GOVDE}: Deep psychological/spiritual analysis (from 'symbolism')

                let semGiris = data.introduction || data.meaning || "Symbolic meaning unavailable.";
                let semGovde = data.symbolism || "";

                // Use finalKey (the actual content source) for the header
                const refBlock = `
SEMBOL: ${finalKey.toUpperCase()}
{SEM_GIRIS}: ${semGiris}
{SEM_GOVDE}: ${semGovde}
`;
                contextBuffer.push(refBlock);

                if (data.cosmicAnalysis) {
                    cosmicAnalysisBuffer.push(data.cosmicAnalysis);
                    console.log(`Cosmic Analysis found for '${finalKey}': ${data.cosmicAnalysis.substring(0, 80)}...`);
                } else {
                    console.log(`NO Cosmic Analysis for '${finalKey}'`);
                }
            }
        });

        const dictionaryContext = contextBuffer.length > 0
            ? `\n### [REFERANS VERİLERİ] (Grounding Data)\n${contextBuffer.join('\n\n')}`
            : "";

        // Use only the FIRST (most dominant) symbol's cosmic analysis for clarity
        let finalCosmicAnalysis = cosmicAnalysisBuffer.length > 0
            ? cosmicAnalysisBuffer[0]
            : null;

        console.log("Dictionary Context length:", dictionaryContext.length);
        console.log("Cosmic Analysis Buffer length:", cosmicAnalysisBuffer.length);
        console.log("Final Cosmic Analysis:", finalCosmicAnalysis ? finalCosmicAnalysis.substring(0, 100) + '...' : 'NULL');

        // --- PASS 2.5: REMOVED (Merged into Pass 1) ---
        // console.log("Detected dream language:", detectedLanguage);

        // --- PASS 3: INTERPRETATION (Synthesize) ---
        const referenceDataAvailable = contextBuffer.length > 0 ? "YES" : "NO";

        const systemPrompt = `
### ROLE & PURPOSE
You are an Expert Jungian Dream Analyst for the DreamBoat app. 
Your task is to interpret the user's dream using the provided **[REFERENCE DATA]**.

**REFERENCE_DATA_AVAILABLE: ${referenceDataAvailable}**

### REFERENCE DATA INSTRUCTION
- **IF REFERENCE_DATA_AVAILABLE is YES**: 
  - Use **{SEM_GIRIS}** (the encyclopedic introduction) for the "definition" field. **TRANSLATE IT** to the target language.
  - Use **{SEM_GOVDE}** (deep psychological/spiritual symbolism) as the foundation for your "interpretation". Synthesize it with the user's specific dream details.
- **IF REFERENCE_DATA_AVAILABLE is NO**: Use your own Jungian knowledge base (Archetypes, Shadow, Anima/Animus). Do NOT invent reference data.

${dictionaryContext}

### INTERPRETATION RULES
1. **Psychological Depth**: Treat symbols as messages from the "Unconscious". Frame the interpretation as an opportunity for internal transformation or confrontation.
2. **Climbing/Falling**: If the dream involves climbing/stairs (Merdiven) and the user is stuck, interpret it as "Libido (Life Energy) Stagnation" or misdirected effort.
3. **Tone**: Mystical, deep, yet modern and clear. Non-judgmental.

### STRUCTURE & FORMAT (CRITICAL)
- **definition**: A short, encyclopedic definition of the **MOST CENTRAL symbol** in the dream (1-2 sentences). If multiple symbols exist, choose the one most relevant to the dream's core theme.
- **interpretation**: The core analysis. MUST be **EXACTLY TWO PARAGRAPHS**. Separate paragraphs with \`\\n\\n\`.
- **Length**: Total interpretation 70-100 words.

### LANGUAGE RULES
- **TARGET LANGUAGE**: **${detectedLanguage}**
- **ALL OUTPUT** (Title, Definition, Interpretation, Cosmic Analysis) MUST be in **${detectedLanguage}**.

### COSMIC ANALYSIS
- Translate the provided "COSMIC ANALYSIS TEXT" to **${detectedLanguage}**.
- **Format**: Return as an **ARRAY of STRINGS**. Each Moon Phase (e.g. New Moon, Waxing Moon, Full Moon, Waning Moon) MUST be a SEPARATE string in the array.
- **Emojis**: Preserve all emojis.
- **ABSOLUTELY NO MARKDOWN**: Do NOT use **bold** markers (** **), *italic*, or any markdown formatting anywhere. NEVER wrap Moon Phase names in ** **. Output PLAIN TEXT only.
- **Moon Phases**: Translate phase names naturally (e.g. "New Moon" → "Yeni Ay" in Turkish). Do NOT add any formatting markers like ** around them.
- **If COSMIC ANALYSIS TEXT is empty or missing**, return: "cosmicAnalysis": []

### OUTPUT FORMAT (JSON ONLY)
**ALL 4 FIELDS ARE MANDATORY. Never omit any field.**
Respond ONLY with this JSON structure:
{
    "title": "Short, engaging title in ${detectedLanguage}",
    "definition": "Symbol definition in ${detectedLanguage}",
    "interpretation": "Analysis text. EXACTLY 2 PARAGRAPHS. Use \\n\\n separator. (${detectedLanguage})",
    "cosmicAnalysis": ["Line 1 with Emoji", "Line 2...", "Line 3..."]
}

### COSMIC ANALYSIS TEXT (To Translate):
"${finalCosmicAnalysis || ''}"
`;

        const completion = await openai.chat.completions.create({
            model: "gpt-4o-mini",
            messages: [
                { role: "system", content: systemPrompt },
                // Move Dream Text to User Message for safety/stability
                { role: "user", content: `DREAM TEXT TO ANALYZE:\n"${dreamText}"` }
            ],
            response_format: { type: "json_object" },
            temperature: 0.5 // Lower temperature for stability
        });

        const responseContent = JSON.parse(completion.choices[0].message.content);
        console.log("GPT Response keys:", Object.keys(responseContent));
        console.log("GPT cosmicAnalysis type:", typeof responseContent.cosmicAnalysis, "isArray:", Array.isArray(responseContent.cosmicAnalysis));
        console.log("GPT cosmicAnalysis value:", JSON.stringify(responseContent.cosmicAnalysis)?.substring(0, 200));

        const title = responseContent.title || "Dream Analysis";
        const definition = responseContent.definition || "";
        let interpretation = responseContent.interpretation || "Interpretation unavailable.";

        // Handle Cosmic Analysis
        // GPT sometimes omits cosmicAnalysis from its output.
        // Fallback: translate the raw API cosmic data if GPT omitted it.
        let cosmicAnalysis = "";
        if (responseContent.cosmicAnalysis) {
            // GPT returned it — use the translated version
            cosmicAnalysis = Array.isArray(responseContent.cosmicAnalysis)
                ? responseContent.cosmicAnalysis.join('\n\n')
                : responseContent.cosmicAnalysis;
        } else if (finalCosmicAnalysis) {
            // GPT omitted it — translate raw API data to target language
            console.log("GPT omitted cosmicAnalysis, translating raw API fallback to", detectedLanguage);
            if (detectedLanguage !== "English") {
                try {
                    const translationCompletion = await openai.chat.completions.create({
                        model: "gpt-4o-mini",
                        messages: [
                            { role: "system", content: `Translate the following cosmic dream analysis text to ${detectedLanguage}. Preserve all emojis. ABSOLUTELY NO MARKDOWN: do NOT use ** ** bold markers or any formatting. Each Moon Phase section must be a separate string in the array. Return ONLY the translated text as a JSON object with a single key "translated" containing an array of strings, one per Moon Phase section.` },
                            { role: "user", content: finalCosmicAnalysis }
                        ],
                        response_format: { type: "json_object" },
                        temperature: 0.2,
                    });
                    const translatedRaw = JSON.parse(translationCompletion.choices[0].message.content);
                    cosmicAnalysis = Array.isArray(translatedRaw.translated)
                        ? translatedRaw.translated.join('\n\n')
                        : translatedRaw.translated || finalCosmicAnalysis;
                    console.log("Fallback cosmic analysis translated successfully");
                } catch (translateErr) {
                    console.error("Fallback cosmic translation failed, using raw English:", translateErr);
                    cosmicAnalysis = finalCosmicAnalysis;
                }
            } else {
                cosmicAnalysis = finalCosmicAnalysis;
            }
        }

        // Post-process: strip any residual ** bold markers from cosmic analysis
        if (cosmicAnalysis) {
            cosmicAnalysis = cosmicAnalysis.replace(/\*\*/g, '');
        }

        console.log("FINAL RETURN cosmicAnalysis:", cosmicAnalysis ? cosmicAnalysis.substring(0, 100) : 'EMPTY/NULL');

        return {
            title,
            definition,
            interpretation,
            cosmicAnalysis
        };

    } catch (error) {
        console.error("Error interpretation:", error);
        throw new HttpsError('internal', "Interpretation failed.");
    }
});

exports.generateDailyTip = onCall({ secrets: [openaiApiKey] }, async (request) => {
    // Rate limit check
    await enforceRateLimit('generateDailyTip', request);

    const openai = new OpenAI({ apiKey: openaiApiKey.value() });

    const { language } = request.data;
    const lang = language || 'en';

    const langMap = {
        'tr': 'Turkish',
        'en': 'English',
        'es': 'Spanish',
        'de': 'German',
        'pt': 'Portuguese'
    };
    const targetLanguage = langMap[lang] || 'English';

    const systemPrompt = `You are a gentle dream - guidance assistant.

Your task is to generate a single, short daily suggestion("Dream Tip") for the user. 
This is NOT a dream interpretation. 
It should feel supportive, reflective, and related to dream awareness, emotional clarity, or inner exploration.

            RULES:
        - Keep the tone warm, calm, and inspirational.
- The tip must fit into 1–3 sentences.
- ** STRICT BAN:** Do NOT use words like "healing", "journey", "process", "improvement", "step", or "grow".
- ** SOFT GUIDANCE ONLY:** Do NOT give specific advice, instruction, diagnosis, or predictions.
- Do NOT use language that implies what the user * should * do, become, or change.
- Keep the suggestion as an open - ended invitation(e.g., "You might reflect on...", "Notice how...").
- Do NOT interpret dreams.
- Keep the suggestion actionable but light(e.g., journaling, reflection, breathing, noticing emotions).
- Avoid therapy - like or medical advice.
- Use a soft, poetic style suited for a dream - themed app.
- Do NOT reference the user's specific life; keep it universal.

The structure should feel like:
        1. A gentle invitation toward self - awareness.
2. A small, peaceful action the user can do today.

Reply in ${targetLanguage} language.
`;

    try {
        const completion = await openai.chat.completions.create({
            messages: [
                { role: "system", content: systemPrompt },
                { role: "user", content: "Generate today's dream guidance tip." },
            ],
            model: "gpt-4o-mini",
            temperature: 0.8,
            max_tokens: 150,
        });

        return {
            result: completion.choices[0].message.content,
            usage: completion.usage
        };
    } catch (error) {
        console.error("Error tip:", error);
        throw new HttpsError('internal', error.message);
    }
});

exports.analyzeDreams = onCall({ secrets: [openaiApiKey] }, async (request) => {
    try {
        // Rate limit check
        await enforceRateLimit('analyzeDreams', request);

        const openai = new OpenAI({ apiKey: openaiApiKey.value() });

        if (!request.data) {
            throw new HttpsError('invalid-argument', 'Missing data payload');
        }

        const { dreams, language } = request.data;
        const lang = language || 'en';

        if (!dreams || !Array.isArray(dreams)) {
            throw new HttpsError('invalid-argument', 'Missing dreams array');
        }

        const systemPrompt = `
You are a weekly Dream Pattern Analysis assistant.

Your task is NOT to interpret a single dream, but to look at all dreams provided for the week and identify patterns, recurring themes, emotional trends, and symbolic clusters.Your tone should be calm, observational, and insightful.

LIMITED DATA RULE:
If fewer than 5 dreams are provided in the weekly set, include this message at the beginning of your analysis:
        "${lang === 'tr' ? 'Girdiğin rüya sayısı sınırlı olduğu için analiz genel eğilim üzerinden yapılmıştır.' : 'Due to limited dream data, analysis is based on general trends.'}"

PATTERN ANALYSIS RULES:
For safe weekly dream sets:
        - Do NOT interpret dreams individually.
- Identify repeated themes, symbols, moods, or scenes across the week.
- Describe emotional progression(how feelings shift from one dream to another).
- Highlight subconscious tendencies or repeating behaviors.
- Note any symbolic clusters that appear in multiple dreams.
- Keep your tone analytical, warm, and reflective.Move away from "progress" narratives.
- ** STRICTLY FORBIDDEN:** Do NOT provide advice, instruction, prediction, or diagnosis.
- ** OPEN - ENDED:** All observations must be descriptive(e.g., "This pattern suggests a focus on...") rather than prescriptive(e.g., "You need to...").
- Your analysis must feel personal, thoughtful, and unique.

CRITICAL WRITING RULES:
        - ALWAYS speak DIRECTLY to the person reading.Use "sen/senin" in Turkish, "you/your" in English.
- NEVER use the word "kullanıcı"(user) or refer to the reader in third person. 
- NEVER use bold formatting with ** symbols.No ** text ** ever.
- Write as if speaking directly to this person about THEIR dreams.

WRITING STYLE:
        - For all sections: Write in FLOWING PROSE format using complete sentences and paragraphs.
        - Do NOT use bullet points or lists in the actual output.
- Each section should read like a mini - essay speaking directly to "sen/you".

OUTPUT STRUCTURE(STRICT MARKDOWN):
Use ### for headers with numbering format "1)" not "1." - example: "### 1) HEADER".NO ** bold ** text.NO bullet points in output.

### 1) ${lang === 'tr' ? 'TEKRARLAYAN TEMALAR' : 'RECURRING THEMES'}
Write a flowing paragraph about recurring themes.Speak directly using "sen/senin".Never say "kullanıcı".

### 2) ${lang === 'tr' ? 'DUYGUSAL DÖNGÜLER' : 'EMOTIONAL CYCLES'}
Write a narrative paragraph about emotional progression.Speak directly using "sen/senin".Never say "kullanıcı".

### 3) ${lang === 'tr' ? 'BİLİNÇALTI EĞİLİMLERİ' : 'SUBCONSCIOUS TENDENCIES'}
Write a cohesive paragraph about subconscious patterns.Speak directly using "sen/senin".Never say "kullanıcı".

### 4) ${lang === 'tr' ? 'SEMBOL AĞI' : 'SYMBOL NETWORK'}
Write a flowing paragraph connecting key symbols.Speak directly using "sen/senin".Never say "kullanıcı".

### 5) ${lang === 'tr' ? 'HAFTALIK ÖZET' : 'WEEKLY SUMMARY'}
Write a deeply personal summary paragraph.Speak directly using "sen/senin".Make it feel like a personal letter about where you are in your life journey.

### 6) ${lang === 'tr' ? 'FARKINDALIK İPUCU' : 'AWARENESS TIP'}
Provide a highly personalized and impactful tip speaking directly to "sen/you".Suggest specific actions like music, art, sports, walking, nature, work - life balance, relationships, creative outlets, or mindfulness.Make it actionable and genuinely helpful.

Your response must be in ${lang === 'tr' ? 'Turkish' : 'English'}.
REMEMBER: No "kullanıcı", no ** bold **, no bullet points.Always "sen/senin"(you / your).Use "1)" numbering format NOT "1." format.
`;

        const completion = await openai.chat.completions.create({
            messages: [
                { role: "system", content: systemPrompt },
                { role: "user", content: `Here are the dreams for the week: \n\n${dreams.join('\n\n')} ` }
            ],
            model: "gpt-4o-mini",
            temperature: 0.7,
        });

        return {
            result: completion.choices[0].message.content,
            usage: completion.usage
        };
    } catch (error) {
        console.error("Error analyzeDreams:", error);
        if (error instanceof HttpsError) throw error;
        throw new HttpsError('internal', error.message || 'Unknown internal error');
    }
});

// Moon & Planet Synchronization Analysis
exports.analyzeMoonSync = onCall({ secrets: [openaiApiKey] }, async (request) => {
    try {
        // Rate limit check
        await enforceRateLimit('analyzeMoonSync', request);

        const openai = new OpenAI({ apiKey: openaiApiKey.value() });

        if (!request.data) {
            throw new HttpsError('invalid-argument', 'Missing data payload');
        }

        const { dreamData, language } = request.data;
        const lang = language || 'en';

        if (!dreamData || !Array.isArray(dreamData)) {
            throw new HttpsError('invalid-argument', 'Missing dreamData array');
        }

        const langMap = {
            'tr': 'Turkish',
            'en': 'English',
            'es': 'Spanish',
            'de': 'German',
            'pt': 'Portuguese'
        };
        const targetLanguage = langMap[lang] || 'English';

        const systemPrompt = `
You are a Cosmic Dream Analysis assistant specializing in Moon Phase correlations and Astronomical Events.

Your task is to analyze the relationship between the user's dream journal data and the lunar/cosmic cycle.
You will receive dream data containing:
- Moon Phase(New Moon, Full Moon, etc.)
    - Astronomical Events(Super Moon, Blood Moon, Eclipses) - these are CRITICAL if present.
- Dream Vividness(1 - 3 scale: 1 = Vague, 2 = Partial, 3 = Clear)
        - Mood & Intensity(1 - 3 scale)
        - Dream Text

GOAL:
Provide a deep, personalized monthly cosmic analysis that connects the user's psychology and subconscious state to the moon's journey.
The user should feel: "My dreams, the Moon's phases, my clarity of memory, and my emotional world are all connected."

ANALYSIS FRAMEWORK:

### 1) ${lang === 'tr' ? 'AY EVRESİ ETKİSİ' : 'MOON PHASE IMPACT'}
- Focus on the dominant moon phase of the period.
- Explain the known psychological / emotional effects of this phase(e.g., New Moon = new beginnings, Full Moon = high energy / release).
- Connect this to the user's specific dream data (moods, intensity).
    - Use a structure like: "In this phase of the Moon, people generally experience X. In your dreams, we see this reflected as Y..."

### 2) ${lang === 'tr' ? 'KOZMİK & ASTRONOMİK OLAYLAR' : 'COSMIC & ASTRONOMICAL EVENTS'}
- ** CRITICAL SECTION:** If the data includes "Super Moon", "Blood Moon", "Solar Eclipse", or "Lunar Eclipse", you MUST focus on it here.
- Explain the intense subconscious effects of these events(Super Moon = heightened clarity / emotion, Eclipses = sudden shifts / shadow work).
- ** Correlate with Vividness & Intensity:** Analyze if dreams were more vivid(High Vividness) or emotionally intense during these events.
- If there are NO special events, discuss the general lunar flow or transition between phases.
- Example connection: "The presence of the Super Moon likely contributed to the high vividness and intense emotions you recorded..." or "The Solar Eclipse energy might explain the shadowy themes..."

### 3) ${lang === 'tr' ? 'RÜYA YOĞUNLUĞU & BERRAKLIK' : 'DREAM INTENSITY & CLARITY'}
- ** DO NOT ** just mention word count.
- ** NO NUMERIC SCALES:** Never say "between 1 and 3" or "level 2".Use descriptive words:
- Intensity: "Light", "Moderate", "Deep", "Intense"(Hafif, Orta, Derin, Yoğun).
   - Vividness: "Vague", "Hazy", "Clear", "Vivid"(Silik, Bulanık, Net, Canlı).
- Analyze the TRIAD: ** Word Count + Mood Intensity + Vividness **.
- Vividness is a key indicator of awareness.High vividness during specific phases suggests an active subconscious.
- Connect this triad to the moon.
- Example: "This moon phase seems to have triggered shorter but highly vivid dreams, suggesting focused subconscious messages..."

### 4) ${lang === 'tr' ? 'KOZMİK İÇGÖRÜLER' : 'COSMIC INSIGHTS'}
- Synthesize everything: Recurring themes + Moon Phase + Cosmic Events + Emotional Intensity.
- What is the "Soul Message" of this period ?
    - Focus on themes of release, confrontation, awakening, or rest based on the data.

### 5) ${lang === 'tr' ? 'AY TAVSİYESİ' : 'LUNAR GUIDANCE'}
- Provide a specific, actionable tip based on the current phase and the user's state (anxious vs peaceful, vivid vs vague).
    - Suggest alignment practices(meditation, journaling, grounding, water rituals).
- Example: "Given the intense Full Moon energy and your vivid dreams, this is a perfect time for..."

TONE & STYLE:
- ** Language:** ${targetLanguage}
- ** Voice:** Gentle, mystical but grounded, non - judgmental.
- ** Perspective:** DIRECTLY address the user as "YOU" (Sen / Senin).Never use "user" or "the dreamer".
- ** Formatting:** Flowing paragraphs. ** NO BULLET POINTS **. ** NO BOLD TEXT **.
- ** Headings:** Use ### 1) Header format.

`;

        // Format dream data for the prompt
        const formattedDreams = dreamData.map((d, i) =>
            `Dream ${i + 1} (${d.date.split('T')[0]}):
Phase: ${d.moonPhase} (${d.isWaxing ? 'Waxing' : 'Waning'})
   Cosmic Events: ${d.astronomicalEvents && d.astronomicalEvents.length > 0 ? d.astronomicalEvents.join(', ') : 'None'}
Mood: ${d.mood} (Intensity: ${d.moodIntensity}/3)
Vividness: ${d.vividness}/3
   Word Count: ${d.wordCount}
Content: ${d.text.substring(0, 300)}...`
        ).join('\n\n');

        const completion = await openai.chat.completions.create({
            messages: [
                { role: "system", content: systemPrompt },
                { role: "user", content: `Here is the dream journal data with moon phase and cosmic event info: \n\n${formattedDreams} ` }
            ],
            model: "gpt-4o-mini",
            temperature: 0.7,
        });

        return {
            result: completion.choices[0].message.content,
            usage: completion.usage
        };
    } catch (error) {
        console.error("Error analyzeMoonSync:", error);
        if (error instanceof HttpsError) throw error;
        throw new HttpsError('internal', error.message || 'Unknown internal error');
    }
});
// Image Generation Feature
exports.generateDreamImage = onCall({ secrets: [openaiApiKey] }, async (request) => {
    // Rate limit check (Generic)
    await enforceRateLimit('generateDreamImage', request);

    // ** AUTHENTICATION CHECK **
    if (!request.auth || !request.auth.uid) {
        console.error("generateDreamImage: No authenticated user");
        throw new HttpsError('unauthenticated', 'User must be authenticated to generate images.');
    }

    const openai = new OpenAI({ apiKey: openaiApiKey.value() });
    const { dreamText, dreamId, isTrial, isDebug } = request.data;
    const uid = request.auth.uid;

    console.log(`generateDreamImage called. uid=${uid}, dreamId=${dreamId}, isTrial=${isTrial}, isDebug=${isDebug}`);

    if (!dreamText || !dreamId) {
        throw new HttpsError('invalid-argument', 'Missing dreamText or dreamId');
    }

    // Get Storage bucket (explicit bucket name for Firebase project)
    // [PRE-FLIGHT CHECK] Validate storage BEFORE expensive OpenAI calls
    let bucket;
    try {
        bucket = admin.storage().bucket('dream-boat-app.firebasestorage.app');
        console.log(`Storage bucket initialized: ${bucket.name}`);

        // Verify bucket is accessible (prevents wasted API costs)
        const [bucketExists] = await bucket.exists();
        if (!bucketExists) {
            console.error("Storage bucket does not exist or is not accessible");
            throw new HttpsError('failed-precondition', 'Storage not available. Please try again later.');
        }
        console.log("Storage bucket verified accessible");
    } catch (storageErr) {
        console.error("Storage initialization error:", storageErr);
        if (storageErr instanceof HttpsError) throw storageErr;
        throw new HttpsError('internal', 'Storage initialization failed: ' + storageErr.message);
    }

    const filePath = `dream_images/${uid}/${dreamId}.png`;
    const file = bucket.file(filePath);

    // [IDEMPOTENCY CHECK]
    // If image exists, return it immediately. Do NOT consume limit.
    try {
        const [exists] = await file.exists();
        if (exists) {
            console.log(`Image already exists for dream ${dreamId}. Returning cached result.`);
            return {
                imageUrl: file.publicUrl(),
                prompt: "Refined prompt not available (Cached Request)"
            };
        }
    } catch (existsErr) {
        console.error("File exists check error:", existsErr);
        // Continue anyway - might be a transient error
    }

    // 1. Strict Date-Based Rate Limiting (YYYY-MM-DD)
    const db = admin.firestore();
    const userStatsRef = db.doc(`users/${uid}/stats/limits`);

    // Get current UTC Date Key
    const now = new Date();
    const dateKey = now.toISOString().split('T')[0]; // "2026-02-01"

    const statsSnap = await userStatsRef.get();
    const stats = statsSnap.data() || {};

    // [DEBUG BYPASS]
    if (isDebug === true) {
        console.log(`[DEBUG BYPASS] Skipping rate limits for user ${uid}`);
    } else {
        if (isTrial) {
            // TRIAL Logic: Max 1 image EVER
            if (stats.totalImagesGenerated && stats.totalImagesGenerated >= 1) {
                throw new HttpsError('resource-exhausted', 'Trial limit reached: 1 image total.');
            }
        } else {
            // PAID Logic: Max 1 image PER DAY
            if (stats.lastImageGenDate === dateKey) {
                throw new HttpsError('resource-exhausted', 'Daily limit reached: 1 image per day.');
            }
        }
    }

    try {
        // 2. Prompt Refinement (Styles Anchor)
        // Convert user's raw dream text into a DALL-E optimized prompt
        const refinement = await openai.chat.completions.create({
            messages: [
                {
                    role: "system", content: `You are an AI Art Director. 
                
                Transform the user's dream into a DALL-E 3 prompt using the following STRICT TEMPLATE.
                
                TEMPLATE:
                "Create a dreamlike color field composition with softly integrated silhouettes, interpreting the following dream through emotion, atmosphere, and symbolic presence rather than literal imagery.
                Human and animal forms should appear as simple, indistinct silhouettes, gently blended into the scene, with no facial features, age, gender, or identifiable traits.
                Convey a sense of place through layered color fields, soft depth, and gradual transitions of light, allowing the environment to feel spacious and immersive without concrete details.
                Use natural asymmetry and subtle variation in scale and distance so figures feel part of a flowing dream space rather than arranged or posed.
                The overall mood should remain calm, soothing, and quietly uplifting, with harmonious colors and balanced, organic composition that avoids darkness, sharp contrast, or unsettling imagery.
                This image is a symbolic, emotional visualization of a dream, not a realistic scene: [INSERT CONCISE VISUAL SUMMARY OF DREAM HERE]"

                INSTRUCTIONS:
                1. Extract the key visual elements from the user's dream.
                2. Insert them into the [INSERT CONCISE VISUAL SUMMARY OF DREAM HERE] slot.
                3. Output ONLY the final populated prompt.` },
                { role: "user", content: `Dream: ${dreamText}` }
            ],
            model: "gpt-4o-mini",
            max_tokens: 300,
        });
        const finalPrompt = refinement.choices[0].message.content;

        // 3. Generate Image (DALL-E 3)
        const imageResponse = await openai.images.generate({
            model: "dall-e-3",
            prompt: finalPrompt,
            n: 1,
            size: "1024x1024",
            response_format: "b64_json", // Get buffer directly to upload
        });

        const imageBuffer = Buffer.from(imageResponse.data[0].b64_json, 'base64');

        // 4. Save File (Already defined)
        await file.save(imageBuffer, {
            metadata: { contentType: 'image/png' },
            public: true, // Make public for easy loading
        });

        // 5. Update Limits in Firestore
        await userStatsRef.set({
            lastImageGenDate: dateKey,
            totalImagesGenerated: admin.firestore.FieldValue.increment(1),
            lastImagePrompt: finalPrompt // Audit
        }, { merge: true });

        // 6. Return Public URL
        const publicUrl = file.publicUrl();

        return {
            imageUrl: publicUrl,
            prompt: finalPrompt
        };

    } catch (error) {
        console.error("Error generating image:", error);
        throw new HttpsError('internal', error.message);
    }
});
