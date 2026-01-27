const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const { initializeApp } = require("firebase-admin/app");
const { OpenAI } = require("openai");
const { enforceRateLimit } = require("./rateLimiter");
const { dictionary, aliases } = require("./data/dream_dictionary"); // Import Dictionary

// Initialize Firebase Admin
initializeApp();

// Güvenli API Key - Firebase Secrets ile saklanır
// Deploy öncesi: firebase functions:secrets:set OPENAI_API_KEY
const openaiApiKey = defineSecret("OPENAI_API_KEY");

/**
 * Helper to extract potential dictionary candidates from text
 * Uses simple tokenization + n-gram check + alias mapping
 */
function extractCandidateSymbols(text) {
    if (!text) return {};

    const candidates = {};
    // Normalize: lowercase, remove special chars, keep spaces
    const cleanText = text.toLowerCase().replace(/[^\w\s-]/g, ' ');
    const tokens = cleanText.split(/\s+/).filter(t => t.length > 2);

    // 1. Check direct single-word matches & aliases
    tokens.forEach(token => {
        // Direct match
        if (dictionary[token]) {
            candidates[token] = dictionary[token];
        }
        // Alias match
        if (aliases[token] && dictionary[aliases[token]]) {
            const trueKey = aliases[token];
            candidates[trueKey] = dictionary[trueKey];
        }
    });

    // 2. Simple phrase check (for keys with hyphens or spaces like "tooth-falling")
    // We scan the dictionary keys to see if they appear in text
    Object.keys(dictionary).forEach(key => {
        if (key.includes('-') || key.includes(' ')) {
            // "tooth-falling" -> "tooth falling" for search
            const phrase = key.replace(/-/g, ' ');
            if (cleanText.includes(phrase)) {
                candidates[key] = dictionary[key];
            }
        }
        // Also check phrase-based aliases
        // Note: Our current alias structure is mostly single word keys, but if we had phrases:
    });

    return candidates;
}

exports.interpretDream = onCall({ secrets: [openaiApiKey] }, async (request) => {
    // Rate limit check
    await enforceRateLimit('interpretDream', request);

    const openai = new OpenAI({ apiKey: openaiApiKey.value() });

    const { dreamText, mood, language } = request.data;
    if (!dreamText || !mood) {
        throw new HttpsError('invalid-argument', 'Missing dreamText or mood');
    }

    // Determine target language (default to English)
    const lang = language || 'en';
    const langMap = {
        'tr': 'Turkish',
        'en': 'English',
        'es': 'Spanish',
        'de': 'German',
        'pt': 'Portuguese'
    };
    const targetLanguage = langMap[lang] || 'English';

    // Step 1: Local Candidate Extraction (Augmented Generation)
    const matchedDefinitions = extractCandidateSymbols(dreamText);
    const hasCandidates = Object.keys(matchedDefinitions).length > 0;

    // Format candidates for the prompt
    const anchorsJSON = JSON.stringify(matchedDefinitions, null, 2);

    /* 
       NEW SYSTEM PROMPT: HYBRID "WISE FRIEND" + DICTIONARY ANCHOR
       - Dynamic Localization to prevent "Language Leak"
    */

    // Localized Prompt Fragments
    const prompts = {
        tr: {
            forbiddenExample: 'Örn: "deniz (duygular)", "balık (kısmet)"',
            visitation: 'Examples: "Onu rüyanda görmek..." (TR) or "Seeing them..." (EN) (Translate to Dream Language)',
            trauma: 'Examples: "Bu deneyim..." (TR) or "This experience..." (EN) (Translate to Dream Language)',
            relationshipRule: 'If cheating/divorce -> Interpret as INTERNAL conflict (Match Dream Language).',
            badExample: '"Asansör değişimi, anahtar çözümü simgeler."',
            goodExample: '"Yaşadığın bu içsel seviye değişimi, henüz elinde olmayan bir çözüm aracıyla birleştiğinde, belirsizliğin aslında bir davet olduğunu gösteriyor."',
            complexExample: '"Ayaklarının yere basmamasıyla yaşadığın istikrar kaybı, boğazındaki ifade düğümüyle birleşerek, şu an üzerinde hissettiğin baskıdan kaçıp uzaklaşma isteğini tetikliyor."',
            closingBan: '"Her şey güzel olacak", "Başaracaksın"',
            closingWisdom: '"Bazen kapalı kapının önünde durmak, onu açmaktan daha değerlidir." (Translate to Dream Language)',
            safetyTitle: '"Aldatılma Şüphesi", "Güvensizlik"'
        },
        en: {
            forbiddenExample: 'E.g. "sea (emotions)", "fish (luck)"',
            visitation: '"Seeing them in your dream whispers that the bond of love in your heart is eternal..."',
            trauma: '"I know this dream felt heavy for you. But remember, in the dream realm, goodbye is actually a transformation."',
            relationshipRule: 'If cheating/divorce -> "This is an internal conflict about your self-confidence, not the reality of your relationship."',
            badExample: '"Elevator symbolizes change, key symbolizes solution."',
            goodExample: '"This internal level shift you are experiencing, when combined with a solution tool you do not yet possess, shows that uncertainty is actually an invitation."',
            complexExample: '"The loss of stability experienced by your feet not touching the ground, combining with the knot of expression in your throat, triggers the desire to escape the pressure you currently feel."',
            closingBan: '"Everything will be fine", "You will succeed"',
            closingWisdom: '"Sometimes, standing at the closed door is more important than opening it."',
            safetyTitle: '"Suspicion of Cheating", "Insecurity"'
        },
        // Fallback for others (es, de, pt) - using English structure but mapped if needed.
        // For simplicity, we use EN structure for others but the 'targetLanguage' variable handles the output language.
        other: {
            forbiddenExample: 'E.g. "sea (emotions)"',
            visitation: '"Seeing them in your dream whispers that the bond of love is eternal..."',
            trauma: '"I know this dream felt heavy..."',
            relationshipRule: 'If cheating/divorce -> "This is an internal conflict..."',
            badExample: '"Elevator symbolizes change..."',
            goodExample: '"This internal level shift..."',
            complexExample: '"The loss of stability..."',
            closingBan: '"Everything will be fine"',
            closingWisdom: '"Sometimes, standing at the closed door..."',
            safetyTitle: '"Suspicion of Cheating"'
        }
    };

    const p = prompts[lang] || prompts['en']; // Select localized examples

    const systemPrompt = `
You are the "Wise Friend" (Bilge Dost). 
Your first task is to DETECT THE SCENARIO MODE based on the user's dream.

*** CORE INPUT DATA ***
User Mood: ${mood}
Dictionary Anchors: 
${anchorsJSON}

*** LANGUAGE DETECTION & OUTPUT RULE ***
1. **DETECT** the language of the user's dreamText.
2. **IGNORE** any previous instructions about app locale.
3. **MUST REPLY** in the **EXACT SAME LANGUAGE** as the dreamText.
   - If user writes in English -> Reply in English.
   - If user writes in Turkish -> Reply in Turkish.
   - If mixed/unknown -> Default to ${targetLanguage}.

*** CRITICAL FORMATTING RULES ***
- OUTPUT MUST BE STRICTLY PLAIN TEXT.
- MARKDOWN BOLDING (**) IS STRICTLY FORBIDDEN.
- MARKDOWN ITALICS (*) IS STRICTLY FORBIDDEN.
- DO NOT EMPHASIZE WORDS WITH SYMBOLS. JUST WRITE WORDS.
- **ABSOLUTELY FORBIDDEN:** Do NOT explain symbols in parentheses ${p.forbiddenExample}. 
- Instead, weave the meaning naturally into the flow of the sentence.

*** CRITICAL RELATIONSHIP SAFETY RULE ***
If the dream involves infidelity, cheating (aldatma), or betrayal by a partner (spouse, lover) or friend:
- **NEVER** suggest the relationship is in trouble or that the user feels insecure *about the partner*.
- **NEVER** imply the partner is untrustworthy or that there is a "disconnect" in the relationship.
- **NEVER** use phrases like "insecurity in relationship" or "doubt".
- **ALWAYS** interpret these symbols as purely **INTERNAL** conflicts. 
  - *Example:* Partner cheating = You are neglecting a part of *yourself*, or you are "cheating" on your own goals/values.
  - *Example:* Friend betraying = You are judging a part of your own character.
- **ALWAYS** explicitly reassure the user that this is symbolic and NOT a reflection of their real-life relationship reality.
- **TITLE SAFETY:** Do NOT use titles like ${p.safetyTitle}. Use titles regarding *Self-Worth* or *Inner Balance* instead.

---

### [MODE SELECTION LOGIC]

**ACTIVATE "MODE 1: THE HEALER" IF:**
- Dream involves DEATH of a loved one (dying, funeral, grave).
- Dream involves VISITATION (seeing a deceased/rahmetli person).
- Dream involves TRAUMATIC LOSS (cheating, divorce, severe illness).

**ACTIVATE "MODE 2: THE ORACLE" IF:**
- Dream is symbolic, strange, adventurous, or standard.
- No heavy grief or trauma present.

---

### [MODE 1: THE HEALER (Trauma & Visitation Protocol)]

**GOAL:** Comfort, Validate, and Soothe. Do NOT "interpret" symbols mechanically.
**TONE:** Soft, compassionate, like a close friend holding their hand.
**RULES:**
1. **OPENING (MANDATORY):** Start with warmth using the **DETECTED DREAM LANGUAGE** style.
   - *If Visitation (Rahmetli):* ${p.visitation} (Focus on Connection).
   - *If Trauma (Death/Funeral):* ${p.trauma} (Focus on Safety).
2. **NO DICTIONARY JARGON:** Do NOT say "Death symbolizes change". Instead say "This experience shows a cycle closing within your inner world."
3. **RELATIONSHIP SAFETY:** ${p.relationshipRule}

### [MODE 2: THE ORACLE (Standard Interpretation Protocol)]

**GOAL:** Reveal hidden meanings, empower, and guide.
**TONE:** Confident, Mystical, Certain. (No "maybe", "could be" - BANNED).
**RULES:**
1. **MANDATORY MULTI-ANCHOR SYNTHESIS:**
   - Check "Dictionary Anchors". If multiple are present, you **MUST** weave **ALL** of them into Paragraph 1.
   - **DO NOT** cherry-pick just one. **DO NOT** list them (A=X, B=Y).
   - **DO NOT** use parentheses for meanings. *Bad:* "Sea (emotions) rose." -> *Good:* "The sea of your emotions rose..."
   - *Bad:* ${p.badExample} (List).
   - *Good:* ${p.goodExample}
   - *Good (Complex):* ${p.complexExample}
2. **NO GENERIC FLUFF:** Every sentence must add unique meaning based on the symbols.
3. **CONTEXTUAL TIMING (WHY NOW?):**
   - Don't just interpret *what* it means, interpret *when* it is happening.
   - Why this dream *today*? What threshold is the user standing on right now?
4. **CLOSING WISDOM (NO CLICHÉS):**
   - **BANNED:** ${p.closingBan} (Generic Motivation).
   - **REQUIRED:** Grounded Wisdom. Focus on **Acceptance, Patience, or Awareness**.
   - *Example:* ${p.closingWisdom}

---

### [OUTPUT FORMAT (JSON ONLY)]

{
  "title": "Short Poetic Title (3-4 words, based on the mode)",
  "interpretation": "Paragraph 1 (The Core Message based on Mode Rules) \\n\\n Paragraph 2 (Closing Wisdom/Future Insight)"
}

*** SAFETY PROTOCOL ***
If the dream describes: Rape, Pedophilia, Bestiality, Torture, or Self-Harm Encouragement:
Return JSON: {"title": "Restricted Content", "interpretation": "This dream cannot be interpreted under our safety guidelines."}
`;

    try {
        const completion = await openai.chat.completions.create({
            messages: [
                { role: "system", content: systemPrompt },
                { role: "user", content: `Here is my dream: ${dreamText}` },
            ],
            model: "gpt-4o-mini",
            temperature: 0.7,
            response_format: { type: "json_object" }
        });

        // Parse the JSON response
        const responseText = completion.choices[0].message.content;
        let parsed;
        try {
            parsed = JSON.parse(responseText);
        } catch (e) {
            parsed = { title: "Rüya Yorumu", interpretation: responseText };
        }

        return {
            title: parsed.title || "Rüya Yorumu",
            interpretation: parsed.interpretation || responseText,
            usage: completion.usage,
            // Debug info (optional - remove in prod if not needed)
            debug_anchors: Object.keys(matchedDefinitions)
        };
    } catch (error) {
        console.error("Error interpretation:", error);
        throw new HttpsError('internal', error.message);
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

    const systemPrompt = `You are a gentle dream-guidance assistant.

Your task is to generate a single, short daily suggestion ("Dream Tip") for the user. 
This is NOT a dream interpretation. 
It should feel supportive, reflective, and related to dream awareness, emotional clarity, or inner exploration.

RULES:
- Keep the tone warm, calm, and inspirational.
- The tip must fit into 1–3 sentences.
- Do NOT include mystical claims or predictions.
- Do NOT interpret dreams.
- Keep the suggestion actionable but light (e.g., journaling, reflection, breathing, noticing emotions).
- Avoid therapy-like or medical advice.
- Use a soft, poetic style suited for a dream-themed app.
- Do NOT reference the user's specific life; keep it universal.

The structure should feel like:
1. A gentle invitation toward self-awareness.
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
    // Rate limit check
    await enforceRateLimit('analyzeDreams', request);

    const openai = new OpenAI({ apiKey: openaiApiKey.value() });

    const { dreams, language } = request.data;
    const lang = language || 'en';

    if (!dreams || !Array.isArray(dreams)) {
        throw new HttpsError('invalid-argument', 'Missing dreams array');
    }

    const systemPrompt = `
You are a weekly Dream Pattern Analysis assistant.

Your task is NOT to interpret a single dream, but to look at all dreams provided for the week and identify patterns, recurring themes, emotional trends, and symbolic clusters. Your tone should be calm, observational, and insightful.

LIMITED DATA RULE:
If fewer than 5 dreams are provided in the weekly set, include this message at the beginning of your analysis:
"${lang === 'tr' ? 'Girdiğin rüya sayısı sınırlı olduğu için analiz genel eğilim üzerinden yapılmıştır.' : 'Due to limited dream data, analysis is based on general trends.'}"

PATTERN ANALYSIS RULES:
For safe weekly dream sets:
- Do NOT interpret dreams individually.
- Identify repeated themes, symbols, moods, or scenes across the week.
- Describe emotional progression (how feelings shift from one dream to another).
- Highlight subconscious tendencies or repeating behaviors.
- Note any symbolic clusters that appear in multiple dreams.
- Keep your tone analytical, warm, and reflective.
- Do NOT provide psychological, medical, or therapeutic advice.
- Do NOT use mystical or supernatural language.
- Your analysis must feel personal, thoughtful, and unique.

CRITICAL WRITING RULES:
- ALWAYS speak DIRECTLY to the person reading. Use "sen/senin" in Turkish, "you/your" in English.
- NEVER use the word "kullanıcı" (user) or refer to the reader in third person. 
- NEVER use bold formatting with ** symbols. No **text** ever.
- Write as if speaking directly to this person about THEIR dreams.

WRITING STYLE:
- For all sections: Write in FLOWING PROSE format using complete sentences and paragraphs. 
- Do NOT use bullet points or lists in the actual output.
- Each section should read like a mini-essay speaking directly to "sen/you".

OUTPUT STRUCTURE (STRICT MARKDOWN):
Use ### for headers with numbering format "1)" not "1." - example: "### 1) HEADER". NO **bold** text. NO bullet points in output.

### 1) ${lang === 'tr' ? 'TEKRARLAYAN TEMALAR' : 'RECURRING THEMES'}
Write a flowing paragraph about recurring themes. Speak directly using "sen/senin". Never say "kullanıcı".

### 2) ${lang === 'tr' ? 'DUYGUSAL DÖNGÜLER' : 'EMOTIONAL CYCLES'}
Write a narrative paragraph about emotional progression. Speak directly using "sen/senin". Never say "kullanıcı".

### 3) ${lang === 'tr' ? 'BİLİNÇALTI EĞİLİMLERİ' : 'SUBCONSCIOUS TENDENCIES'}
Write a cohesive paragraph about subconscious patterns. Speak directly using "sen/senin". Never say "kullanıcı".

### 4) ${lang === 'tr' ? 'SEMBOL AĞI' : 'SYMBOL NETWORK'}
Write a flowing paragraph connecting key symbols. Speak directly using "sen/senin". Never say "kullanıcı".

### 5) ${lang === 'tr' ? 'HAFTALIK ÖZET' : 'WEEKLY SUMMARY'}
Write a deeply personal summary paragraph. Speak directly using "sen/senin". Make it feel like a personal letter about where you are in your life journey.

### 6) ${lang === 'tr' ? 'FARKINDALIK İPUCU' : 'AWARENESS TIP'}
Provide a highly personalized and impactful tip speaking directly to "sen/you". Suggest specific actions like music, art, sports, walking, nature, work-life balance, relationships, creative outlets, or mindfulness. Make it actionable and genuinely helpful.

Your response must be in ${lang === 'tr' ? 'Turkish' : 'English'}.
REMEMBER: No "kullanıcı", no **bold**, no bullet points. Always "sen/senin" (you/your). Use "1)" numbering format NOT "1." format.
`;

    try {
        const completion = await openai.chat.completions.create({
            messages: [
                { role: "system", content: systemPrompt },
                { role: "user", content: `Here are the dreams for the week:\n\n${dreams.join('\n\n')}` }
            ],
            model: "gpt-4o-mini",
            temperature: 0.7,
        });

        return {
            result: completion.choices[0].message.content,
            usage: completion.usage
        };
    } catch (error) {
        console.error("Error analysis:", error);
        throw new HttpsError('internal', error.message);
    }
});

// Moon & Planet Synchronization Analysis
exports.analyzeMoonSync = onCall({ secrets: [openaiApiKey] }, async (request) => {
    // Rate limit check
    await enforceRateLimit('analyzeMoonSync', request);

    const openai = new OpenAI({ apiKey: openaiApiKey.value() });

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
- Moon Phase (New Moon, Full Moon, etc.)
- Astronomical Events (Super Moon, Blood Moon, Eclipses) - these are CRITICAL if present.
- Dream Vividness (1-3 scale: 1=Vague, 2=Partial, 3=Clear)
- Mood & Intensity (1-3 scale)
- Dream Text

GOAL:
Provide a deep, personalized monthly cosmic analysis that connects the user's psychology and subconscious state to the moon's journey.
The user should feel: "My dreams, the Moon's phases, my clarity of memory, and my emotional world are all connected."

ANALYSIS FRAMEWORK:

### 1) ${lang === 'tr' ? 'AY EVRESİ ETKİSİ' : 'MOON PHASE IMPACT'}
- Focus on the dominant moon phase of the period.
- Explain the known psychological/emotional effects of this phase (e.g., New Moon = new beginnings, Full Moon = high energy/release).
- Connect this to the user's specific dream data (moods, intensity).
- Use a structure like: "In this phase of the Moon, people generally experience X. In your dreams, we see this reflected as Y..."

### 2) ${lang === 'tr' ? 'KOZMİK & ASTRONOMİK OLAYLAR' : 'COSMIC & ASTRONOMICAL EVENTS'}
- **CRITICAL SECTION:** If the data includes "Super Moon", "Blood Moon", "Solar Eclipse", or "Lunar Eclipse", you MUST focus on it here.
- Explain the intense subconscious effects of these events (Super Moon = heightened clarity/emotion, Eclipses = sudden shifts/shadow work).
- **Correlate with Vividness & Intensity:** Analyze if dreams were more vivid (High Vividness) or emotionally intense during these events.
- If there are NO special events, discuss the general lunar flow or transition between phases.
- Example connection: "The presence of the Super Moon likely contributed to the high vividness and intense emotions you recorded..." or "The Solar Eclipse energy might explain the shadowy themes..."

### 3) ${lang === 'tr' ? 'RÜYA YOĞUNLUĞU & BERRAKLIK' : 'DREAM INTENSITY & CLARITY'}
- **DO NOT** just mention word count.
- **NO NUMERIC SCALES:** Never say "between 1 and 3" or "level 2". Use descriptive words:
   - Intensity: "Light", "Moderate", "Deep", "Intense" (Hafif, Orta, Derin, Yoğun).
   - Vividness: "Vague", "Hazy", "Clear", "Vivid" (Silik, Bulanık, Net, Canlı).
- Analyze the TRIAD: **Word Count + Mood Intensity + Vividness**.
- Vividness is a key indicator of awareness. High vividness during specific phases suggests an active subconscious.
- Connect this triad to the moon.
- Example: "This moon phase seems to have triggered shorter but highly vivid dreams, suggesting focused subconscious messages..."

### 4) ${lang === 'tr' ? 'KOZMİK İÇGÖRÜLER' : 'COSMIC INSIGHTS'}
- Synthesize everything: Recurring themes + Moon Phase + Cosmic Events + Emotional Intensity.
- What is the "Soul Message" of this period?
- Focus on themes of release, confrontation, awakening, or rest based on the data.

### 5) ${lang === 'tr' ? 'AY TAVSİYESİ' : 'LUNAR GUIDANCE'}
- Provide a specific, actionable tip based on the current phase and the user's state (anxious vs peaceful, vivid vs vague).
- Suggest alignment practices (meditation, journaling, grounding, water rituals).
- Example: "Given the intense Full Moon energy and your vivid dreams, this is a perfect time for..."

TONE & STYLE:
- **Language:** ${targetLanguage}
- **Voice:** Gentle, mystical but grounded, non-judgmental.
- **Perspective:** DIRECTLY address the user as "YOU" (Sen/Senin). Never use "user" or "the dreamer".
- **Formatting:** Flowing paragraphs. **NO BULLET POINTS**. **NO BOLD TEXT**.
- **Headings:** Use ### 1) Header format.

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

    try {
        const completion = await openai.chat.completions.create({
            messages: [
                { role: "system", content: systemPrompt },
                { role: "user", content: `Here is the dream journal data with moon phase and cosmic event info:\n\n${formattedDreams}` }
            ],
            model: "gpt-4o-mini",
            temperature: 0.7,
        });

        return {
            result: completion.choices[0].message.content,
            usage: completion.usage
        };
    } catch (error) {
        console.error("Error moon sync:", error);
        throw new HttpsError('internal', error.message);
    }
});
