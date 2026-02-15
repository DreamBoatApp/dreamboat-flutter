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

/**
 * Detects the dominant language of dream texts using GPT-4o-mini.
 * Samples up to 3 dreams for efficiency.
 * @param {OpenAI} openai - OpenAI client instance
 * @param {string[]} dreamTexts - Array of dream text strings
 * @returns {Promise<{lang: string, fullName: string}>} e.g. {lang: 'tr', fullName: 'Turkish'}
 */
async function detectDreamLanguage(openai, dreamTexts) {
    // Sample up to 3 dreams for detection
    const sample = dreamTexts.slice(0, 3).join('\n---\n');

    try {
        const detection = await openai.chat.completions.create({
            model: "gpt-4o-mini",
            messages: [
                { role: "system", content: `Detect the language of the following dream texts. Reply with ONLY the standard English name of the language (e.g., "Turkish", "English", "Spanish", "German", "Portuguese"). If texts are in multiple languages, reply with the DOMINANT language.` },
                { role: "user", content: sample }
            ],
            max_tokens: 10,
            temperature: 0,
        });

        const rawLang = (detection.choices[0].message.content || 'English').trim().toLowerCase();
        const fullName = LANG_NORMALIZE_MAP[rawLang] || (rawLang.charAt(0).toUpperCase() + rawLang.slice(1));

        // Reverse map to get short code
        const langCodeMap = { 'Turkish': 'tr', 'English': 'en', 'Spanish': 'es', 'German': 'de', 'Portuguese': 'pt', 'Dutch': 'nl', 'Italian': 'it', 'Russian': 'ru', 'French': 'fr' };
        const lang = langCodeMap[fullName] || 'en';

        console.log(`Language detected: ${fullName} (${lang})`);
        return { lang, fullName };
    } catch (e) {
        console.error('Language detection failed, falling back to English:', e);
        return { lang: 'en', fullName: 'English' };
    }
}

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
        2. VALIDITY CHECK: Determine if the text is a valid dream description.
           - is_valid_dream: true if the text describes ANY kind of dream, personal experience, story, thought, or has ANY semantic meaning in ANY language.
           - is_valid_dream: false ONLY if the text is random characters, keyboard spam (e.g. "asdfghjkl"), repeated nonsense, or completely meaningless gibberish with NO semantic content in ANY language.
           - CRITICAL: When in doubt, ALWAYS return true. Creative, unusual, short, or poetic dreams are VALID. Single words that are real words are VALID. Only pure gibberish with zero meaning is invalid.
        3. DETECT the language of the dream (Output as 'detected_language').
        4. EXTRACT 2-4 dominant symbols. ONLY extract concrete objects, beings, places, or natural elements. Do NOT extract actions (chase, cry) or emotions (fear, joy).
        5. **CRITICAL**: ALL symbols MUST be in **ENGLISH**. Translate every symbol to its English equivalent. NEVER output symbols in the dream's original language.
        6. **SINGLE WORD ONLY**: Each symbol must be exactly ONE word. No adjectives, no colors, no compounds.
        
        WRONG: "ÖĞRENCİ", "AT", "EV", "BAHÇE", "YEMEK", "ZÜRAFA", "BLACK HORSE", "BIG SNAKE"
        CORRECT: "STUDENT", "HORSE", "HOME", "GARDEN", "FOOD", "GIRAFFE", "HORSE", "SNAKE"
        
        Examples:
        Input: "Rüyamda koca bir yılanın beni kovaladığını gördüm."
        Output: { "is_valid_dream": true, "detected_language": "Turkish", "symbols": ["SNAKE"] }
        
        Input: "asdfghjklqwerty zxcvbnm"
        Output: { "is_valid_dream": false, "detected_language": "Unknown", "symbols": [] }
        
        Input: "A baby was crying and then an angel appeared near the ocean."
        Output: { "is_valid_dream": true, "detected_language": "English", "symbols": ["BABY", "ANGEL", "OCEAN"] }
        
        OUTPUT FORMAT (JSON ONLY):
        {
          "is_valid_dream": true/false,
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

            // --- GIBBERISH CHECK ---
            if (raw.is_valid_dream === false) {
                console.log("Dream rejected: gibberish/nonsense input detected");
                return {
                    title: null,
                    interpretation: null,
                    cosmicAnalysis: "",
                    rejected: true,
                    rejectionReason: 'gibberish'
                };
            }

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

        const { dreams } = request.data;
        // Detect language from dream content instead of UI locale
        let lang = 'en';
        let detectedFullName = 'English';

        if (!dreams || !Array.isArray(dreams)) {
            throw new HttpsError('invalid-argument', 'Missing dreams array');
        }

        // Detect language from actual dream texts
        const detected = await detectDreamLanguage(openai, dreams);
        lang = detected.lang;
        detectedFullName = detected.fullName;
        console.log(`analyzeDreams: Using detected language: ${detectedFullName} (${lang})`);

        const systemPrompt = `
You are a weekly Dream Pattern Analysis assistant.

Your task is NOT to interpret a single dream, but to look at all dreams provided for the week and identify patterns, recurring themes, emotional trends, and symbolic clusters.Your tone should be calm, observational, and insightful.

LIMITED DATA RULE:
If fewer than 5 dreams are provided in the weekly set, include a brief note at the beginning of your analysis (in ${detectedFullName}) explaining that due to limited dream data, the analysis is based on general trends.

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

HEADER TRANSLATION RULE (CRITICAL):
All section headers below are given in English for structural reference. You MUST translate each header into ${detectedFullName} in your output. For example, if the target language is German, "RECURRING THEMES" becomes "WIEDERKEHRENDE THEMEN". If French, it becomes "THÈMES RÉCURRENTS". NEVER output English headers unless the target language IS English.

### 1) RECURRING THEMES
Write a flowing paragraph about recurring themes. Speak directly using second person ("you/your" or equivalent in target language). Never refer to the reader as "user".

### 2) EMOTIONAL CYCLES
Write a narrative paragraph about emotional progression. Speak directly using second person. Never refer to the reader as "user".

### 3) SUBCONSCIOUS TENDENCIES
Write a cohesive paragraph about subconscious patterns. Speak directly using second person. Never refer to the reader as "user".

### 4) SYMBOL NETWORK
Write a flowing paragraph connecting key symbols. Speak directly using second person. Never refer to the reader as "user".

### 5) WEEKLY SUMMARY
Write a deeply personal summary paragraph. Speak directly using second person. Make it feel like a personal letter about where you are in your life journey.

### 6) AWARENESS TIP
Provide a highly personalized and impactful tip speaking directly to the reader. Suggest specific actions like music, art, sports, walking, nature, work-life balance, relationships, creative outlets, or mindfulness. Make it actionable and genuinely helpful.

Your ENTIRE response (including ALL section headers) must be in ${detectedFullName}.
REMEMBER: No "user/kullanıcı", no ** bold **, no bullet points. Always second person (you/your). Use "1)" numbering format NOT "1." format.
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

        const { dreamData } = request.data;

        if (!dreamData || !Array.isArray(dreamData)) {
            throw new HttpsError('invalid-argument', 'Missing dreamData array');
        }

        // Detect language from actual dream texts
        const dreamTexts = dreamData.map(d => d.text).filter(Boolean);
        const detected = await detectDreamLanguage(openai, dreamTexts);
        const lang = detected.lang;
        const targetLanguage = detected.fullName;
        console.log(`analyzeMoonSync: Using detected language: ${targetLanguage} (${lang})`);

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

HEADER TRANSLATION RULE (CRITICAL):
All section headers below are given in English for structural reference. You MUST translate each header into ${targetLanguage} in your output. For example, if the target language is German, "MOON PHASE IMPACT" becomes "MONDPHASEN-EINFLUSS". If French, it becomes "IMPACT DE LA PHASE LUNAIRE". NEVER output English headers unless the target language IS English.

### 1) MOON PHASE IMPACT
- Focus on the dominant moon phase of the period.
- Explain the known psychological / emotional effects of this phase(e.g., New Moon = new beginnings, Full Moon = high energy / release).
- Connect this to the user's specific dream data (moods, intensity).
    - Use a structure like: "In this phase of the Moon, people generally experience X. In your dreams, we see this reflected as Y..."

### 2) COSMIC & ASTRONOMICAL EVENTS
- CRITICAL SECTION: If the data includes "Super Moon", "Blood Moon", "Solar Eclipse", or "Lunar Eclipse", you MUST focus on it here.
- Explain the intense subconscious effects of these events(Super Moon = heightened clarity / emotion, Eclipses = sudden shifts / shadow work).
- Correlate with Vividness & Intensity: Analyze if dreams were more vivid(High Vividness) or emotionally intense during these events.
- If there are NO special events, discuss the general lunar flow or transition between phases.
- Example connection: "The presence of the Super Moon likely contributed to the high vividness and intense emotions you recorded..." or "The Solar Eclipse energy might explain the shadowy themes..."

### 3) DREAM INTENSITY & CLARITY
- DO NOT just mention word count.
- NO NUMERIC SCALES: Never say "between 1 and 3" or "level 2". Use descriptive words:
- Intensity: "Light", "Moderate", "Deep", "Intense".
   - Vividness: "Vague", "Hazy", "Clear", "Vivid".
- Analyze the TRIAD: Word Count + Mood Intensity + Vividness.
- Vividness is a key indicator of awareness. High vividness during specific phases suggests an active subconscious.
- Connect this triad to the moon.
- Example: "This moon phase seems to have triggered shorter but highly vivid dreams, suggesting focused subconscious messages..."

### 4) COSMIC INSIGHTS
- Synthesize everything: Recurring themes + Moon Phase + Cosmic Events + Emotional Intensity.
- What is the "Soul Message" of this period?
    - Focus on themes of release, confrontation, awakening, or rest based on the data.

### 5) LUNAR GUIDANCE
- Provide a specific, actionable tip based on the current phase and the user's state (anxious vs peaceful, vivid vs vague).
    - Suggest alignment practices(meditation, journaling, grounding, water rituals).
- Example: "Given the intense Full Moon energy and your vivid dreams, this is a perfect time for..."

TONE & STYLE:
- Language: ${targetLanguage}
- Voice: Gentle, mystical but grounded, non-judgmental.
- Perspective: DIRECTLY address the reader as "YOU" (second person). Never use "user" or "the dreamer".
- Formatting: Flowing paragraphs. NO BULLET POINTS. NO BOLD TEXT.
- Headings: Use ### 1) Header format. ALL HEADERS MUST BE IN ${targetLanguage}.

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
exports.generateDreamImage = onCall({ secrets: [openaiApiKey], memory: '512MiB', timeoutSeconds: 120 }, async (request) => {
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
                    role: "system", content: `You are a Dream Art Director specializing in symbolic, emotionally resonant dream visualization.

                TASK: Transform the user's dream into a DALL-E 3 prompt that captures the SPECIFIC atmosphere, setting, and emotional core of THIS particular dream — not a generic dreamscape.

                ANALYSIS STEPS (internal, do not output these — use them to guide your prompt):
                1. Identify the PRIMARY SETTING (school? forest? ocean? home? city? sky? underground?)
                2. Identify the EMOTIONAL CORE (anxiety? wonder? nostalgia? fear? peace? confusion? joy?)
                3. Identify 1-3 KEY VISUAL ANCHORS — the specific objects or elements that make this dream unique
                4. Choose a COLOR MOOD that matches the emotion (cool blues for loneliness, warm ambers for nostalgia, deep purples for mystery, soft greens for peace, etc.)

                OUTPUT: A single DALL-E prompt following this structure — fill in the bracketed sections with dream-specific content:

                "A soft color field painting depicting [SPECIFIC SETTING — describe the actual place as it would realistically look, but rendered with soft focus and gentle light. A school corridor should look like a real school corridor with plain walls and rectangular doors, NOT a cathedral with arches. A home kitchen should look like a kitchen, NOT a palace hall].

                [KEY VISUAL ANCHORS as soft symbolic elements woven into the scene — e.g. a small solitary silhouette searching through the space, a distant figure gesturing from the far end, a key floating in mid-air, a door slightly ajar with light spilling through].

                The palette is [EMOTION-DRIVEN COLORS — e.g. cool institutional blues and greys with warm amber light spilling from one distant doorway, evoking nostalgic longing and gentle unease].

                All living beings — humans AND animals — appear as simple, featureless silhouettes with no facial details, breed, size specificity, age, or gender indicators. A dog is just a generic dog-shaped silhouette, not a specific breed. A person is just a human-shaped silhouette.

                The overall composition feels like looking into a memory — softly focused, emotionally vivid, quietly atmospheric. Use layered depth, gentle light transitions, and natural asymmetry. Avoid darkness, horror, sharp contrast, or unsettling imagery.

                ABSOLUTELY NO TEXT, LETTERS, WORDS, NUMBERS, OR WRITING OF ANY KIND anywhere in the image."

                RULES:
                1. Output ONLY the final prompt — no commentary, no explanation.
                2. The setting MUST be architecturally accurate to the dream — a school looks like a school, a house looks like a house. Do NOT embellish with grandiose elements like arches, columns, domes, or cathedral ceilings unless the dream specifically mentions them.
                3. Include at most 1-3 figures/silhouettes — avoid crowd scenes.
                4. NEVER include any instruction that would result in text or writing in the image.
                5. Keep the prompt under 250 words.` },
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
