const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const { OpenAI } = require("openai");
const cors = require("cors")({ origin: true });

// Güvenli API Key - Firebase Secrets ile saklanır
// Deploy öncesi: firebase functions:secrets:set OPENAI_API_KEY
const openaiApiKey = defineSecret("OPENAI_API_KEY");

exports.interpretDream = onRequest({ secrets: [openaiApiKey] }, (req, res) => {
    const openai = new OpenAI({ apiKey: openaiApiKey.value() });
    cors(req, res, async () => {
        try {
            if (req.method !== "POST") return res.status(405).send("Method Not Allowed");

            const { dreamText, mood, language } = req.body;
            if (!dreamText || !mood) return res.status(400).send("Missing dreamText or mood");

            const systemPrompt = `
You are a structured dream interpretation assistant.

Your goal is to give a clear, textbook-style dream interpretation based on the user’s dream text. 
Your tone should be confident, organized, and symbolic — not speculative, not filled with "maybe" or "possibly."

NON-DREAM OR SENSITIVE CONTENT RULE:
If the input text is:
- Clearly NOT a dream (e.g. "hello", "test", random gibberish, just a name).
- Contains sensitive/explicit content (sexual violence, rape, suicide, murder, torture).
- Too abstract or meaningless to be interpreted as a dream.

Then respond with this JSON:
{"title": "Yorumlanamadı", "interpretation": "Girilmiş olan rüya çok fazla özel anlamlar içerdiğinden yorumlanamadı."}

SHORT DREAM RULE:
If the dream text is too short (e.g. less than 5 words) but still looks like valid text, respond with:
{"title": "Kısa Rüya", "interpretation": "Yorumlanmak için çok kısa. Daha detaylı rüyalar daha zengin yorumlar alır."}

INTERPRETATION RULES:
For normal dreams:
- Detect the language of the user's dream input.
- Reply in the SAME language as the input.
- Do NOT repeat the entire dream back.
- Use direct, structured symbolic reasoning.
- Avoid phrases such as “maybe”, “possibly”, “it could be.”
- Speak with clarity: identify the symbolic roles of objects, emotions, actions, and transitions.
- Avoid psychological or medical advice.
- Avoid mystical or supernatural claims.
- The tone should resemble an academic, symbolic dream analysis.

CRITICAL VOICE/TONE RULE:
- ALWAYS address the dreamer directly as "YOU" (Sen).
- NEVER use third-person terms like "the dreamer" (rüya sahibi), "the person" (kişi), or "the individual" (birey).
- In Turkish, use "senin", "sana", "iç dünyan" instead of "kişinin", "onun".
- Example: Instead of "Bu rüya kişinin korkularını yansıtır", say "Bu rüya senin korkularını yansıtır".

OUTPUT FORMAT (STRICT JSON):
You MUST respond with a valid JSON object containing exactly two fields:
1. "title": A short, poetic, mystical title for the dream (3-5 words max). Examples: "Yere Değmeyen Ayaklar", "Kayıp Şehrin Kapıları", "Sessiz Ormanın Çığlığı"
2. "interpretation": The dream interpretation as a SINGLE, COHESIVE PARAGRAPH with NO formatting (no bullets, no bold, no numbered lists).

Example response format:
{"title": "Uçuşan Gölgeler", "interpretation": "Bu rüya, bilinçaltındaki özgürlük arayışını sembolize ediyor..."}

Your writing should feel structured, decisive, and rooted in symbolic analysis rather than guesswork.
User Mood Context: ${mood}
`;

            const completion = await openai.chat.completions.create({
                messages: [
                    { role: "system", content: systemPrompt },
                    { role: "user", content: `Here is the dream: ${dreamText}` },
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
                // Fallback if JSON parsing fails
                parsed = { title: null, interpretation: responseText };
            }

            res.json({
                title: parsed.title || null,
                interpretation: parsed.interpretation || responseText
            });
        } catch (error) {
            console.error("Error interpretation:", error);
            res.status(500).json({ error: error.message });
        }
    });
});

exports.generateDailyTip = onRequest({ secrets: [openaiApiKey] }, (req, res) => {
    const openai = new OpenAI({ apiKey: openaiApiKey.value() });
    cors(req, res, async () => {
        try {
            if (req.method !== "POST") return res.status(405).send("Method Not Allowed");

            const { language } = req.body; // 'tr', 'en', 'es', 'pt', 'de'
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

Your task is to generate a single, short daily suggestion (“Dream Tip”) for the user. 
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
- Do NOT reference the user’s specific life; keep it universal.

The structure should feel like:
1. A gentle invitation toward self-awareness.
2. A small, peaceful action the user can do today.

Reply in ${targetLanguage} language.
`;

            const completion = await openai.chat.completions.create({
                messages: [
                    { role: "system", content: systemPrompt },
                    { role: "user", content: "Generate today's dream guidance tip." },
                ],
                model: "gpt-4o-mini",
                temperature: 0.8,
                max_tokens: 150,
            });

            res.json({ result: completion.choices[0].message.content });
        } catch (error) {
            console.error("Error tip:", error);
            res.status(500).json({ error: error.message });
        }
    });
});

exports.analyzeDreams = onRequest({ secrets: [openaiApiKey] }, (req, res) => {
    const openai = new OpenAI({ apiKey: openaiApiKey.value() });
    cors(req, res, async () => {
        try {
            if (req.method !== "POST") return res.status(405).send("Method Not Allowed");

            const { dreams, language } = req.body;
            const lang = language || 'en';

            if (!dreams || !Array.isArray(dreams)) return res.status(400).send("Missing dreams array");

            const systemPrompt = `
You are a weekly Dream Pattern Analysis assistant.

Your task is NOT to interpret a single dream, but to look at all dreams provided for the week and identify patterns, recurring themes, emotional trends, and symbolic clusters. Your tone should be calm, observational, and insightful.

SENSITIVE CONTENT RULE:
If any dream in the weekly list contains elements such as:
- sexual violence
- rape
- murder or attempted murder
- suicide or self-harm
- extreme or graphic violence
- torture
- explicit sexual acts

THEN DO NOT analyze the patterns.

Instead, respond with:
"${lang === 'tr' ? 'Bu haftaki rüyalarda hassas içerikler bulunuyor. Bu tür temalar üzerinden analiz yapmak doğru olmaz.' : 'This week\'s dreams contain sensitive content. It would not be appropriate to analyze these themes.'}"

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
Use ### for headers. NO **bold** text. NO bullet points in output.

### 1. ${lang === 'tr' ? 'TEKRARLAYAN TEMALAR' : 'RECURRING THEMES'}
Write a flowing paragraph about recurring themes. Speak directly using "sen/senin". Never say "kullanıcı".

### 2. ${lang === 'tr' ? 'DUYGUSAL DÖNGÜLER' : 'EMOTIONAL CYCLES'}
Write a narrative paragraph about emotional progression. Speak directly using "sen/senin". Never say "kullanıcı".

### 3. ${lang === 'tr' ? 'BİLİNÇALTI EĞİLİMLERİ' : 'SUBCONSCIOUS TENDENCIES'}
Write a cohesive paragraph about subconscious patterns. Speak directly using "sen/senin". Never say "kullanıcı".

### 4. ${lang === 'tr' ? 'SEMBOL AĞI' : 'SYMBOL NETWORK'}
Write a flowing paragraph connecting key symbols. Speak directly using "sen/senin". Never say "kullanıcı".

### 5. ${lang === 'tr' ? 'HAFTALIK ÖZET' : 'WEEKLY SUMMARY'}
Write a deeply personal summary paragraph. Speak directly using "sen/senin". Make it feel like a personal letter about where you are in your life journey.

### 6. ${lang === 'tr' ? 'FARKINDALIK İPUCU' : 'AWARENESS TIP'}
Provide a highly personalized and impactful tip speaking directly to "sen/you". Suggest specific actions like music, art, sports, walking, nature, work-life balance, relationships, creative outlets, or mindfulness. Make it actionable and genuinely helpful.

Your response must be in ${lang === 'tr' ? 'Turkish' : 'English'}.
REMEMBER: No "kullanıcı", no **bold**, no bullet points. Always "sen/senin" (you/your).
`;

            const completion = await openai.chat.completions.create({
                messages: [
                    { role: "system", content: systemPrompt },
                    { role: "user", content: `Here are the dreams for the week:\n\n${dreams.join('\n\n')}` }
                ],
                model: "gpt-4o-mini",
                temperature: 0.7,
            });

            res.json({ result: completion.choices[0].message.content });
        } catch (error) {
            console.error("Error analysis:", error);
            res.status(500).json({ error: error.message });
        }
    });
});

// Moon & Planet Synchronization Analysis
exports.analyzeMoonSync = onRequest({ secrets: [openaiApiKey] }, (req, res) => {
    const openai = new OpenAI({ apiKey: openaiApiKey.value() });
    cors(req, res, async () => {
        try {
            if (req.method !== "POST") return res.status(405).send("Method Not Allowed");

            const { dreamData, language } = req.body;
            const lang = language || 'en';

            if (!dreamData || !Array.isArray(dreamData)) return res.status(400).send("Missing dreamData array");

            const langMap = {
                'tr': 'Turkish',
                'en': 'English',
                'es': 'Spanish',
                'de': 'German',
                'pt': 'Portuguese'
            };
            const targetLanguage = langMap[lang] || 'English';

            const systemPrompt = `
You are a Cosmic Dream Analysis assistant specializing in Moon Phase correlations.

Your task is to analyze the relationship between dreams and lunar phases. You will receive dream data with moon phase information and must identify patterns between dream characteristics and the lunar cycle.

SENSITIVE CONTENT RULE:
If any dream contains elements such as sexual violence, rape, murder, suicide, self-harm, extreme violence, torture, or explicit sexual acts:
RESPOND EXACTLY WITH: "${lang === 'tr' ? 'Bu dönemdeki rüyalarda hassas içerikler bulunuyor. Bu tür temalar üzerinden kozmik analiz yapmak doğru olmaz.' : 'Dreams in this period contain sensitive content. It would not be appropriate to perform cosmic analysis on these themes.'}"

CRITICAL WRITING RULES:
- ALWAYS speak DIRECTLY to the person reading. Use "sen/senin" in Turkish, "you/your" in English. 
- NEVER use the word "kullanıcı" (user) or refer to the reader in third person.
- NEVER use bold formatting with ** symbols. No **text** ever.
- Write as if speaking directly to this person about THEIR dreams.
- Use flowing prose paragraphs, NOT bullet points or lists.

ANALYSIS FOCUS:
1. Moon Phase Impact: Explain the general dream tendencies for each moon phase present, then connect these tendencies with the person's actual dreams and their selected mood tags
2. Dream Intensity: Analyze word count and detail variations across moon phases, then END THIS SECTION with a relevant sleep/dream tip specific to the moon phase
3. Cosmic Insights: Identify unique lunar-dream patterns based on recurring themes, symbols, and mood correlations
4. Lunar Guidance: For EACH moon phase present in the dreams, explain that specific phase's influence. Provide practical sleep and dream awareness advice tailored to lunar cycles

RULES:
- Be mystical yet grounded - blend cosmic wisdom with psychological observation
- Do NOT provide medical or psychological advice
- Keep the tone warm, insightful, and slightly mystical
- Always mention specific moon phases by name when discussing patterns
- Write everything in flowing prose paragraphs, NOT bullet points

OUTPUT STRUCTURE (STRICT MARKDOWN):
Use ### for headers. Write all content as flowing paragraphs. NO bullet points. NO **bold** text.

### 1. ${lang === 'tr' ? 'AY EVRESİ ETKİSİ' : 'MOON PHASE IMPACT'}
Write a flowing paragraph explaining moon phase tendencies and how they connect to the dreams and moods. Speak directly using "sen/senin".

### 2. ${lang === 'tr' ? 'RÜYA YOĞUNLUĞU' : 'DREAM INTENSITY'}
Write a flowing paragraph about dream intensity. End with a practical sleep tip. Speak directly using "sen/senin".

### 3. ${lang === 'tr' ? 'KOZMİK İÇGÖRÜLER' : 'COSMIC INSIGHTS'}
Write a flowing paragraph about unique patterns discovered. Speak directly using "sen/senin".

### 4. ${lang === 'tr' ? 'AY TAVSİYESİ' : 'LUNAR GUIDANCE'}
Write a flowing paragraph with personalized guidance for each moon phase. Include sleep advice. Speak directly using "sen/senin".

Respond in ${targetLanguage}.
REMEMBER: No "kullanıcı", no **bold**, no bullet points. Always "sen/senin" (you/your).
`;

            // Format dream data for the prompt
            const formattedDreams = dreamData.map((d, i) =>
                `Dream ${i + 1} (${d.moonPhase}, ${d.isWaxing ? 'Waxing' : 'Waning'}):
Mood: ${d.mood}
Word Count: ${d.wordCount}
Content: ${d.text.substring(0, 200)}...`
            ).join('\n\n');

            const completion = await openai.chat.completions.create({
                messages: [
                    { role: "system", content: systemPrompt },
                    { role: "user", content: `Here is the dream data with moon phase information:\n\n${formattedDreams}` }
                ],
                model: "gpt-4o-mini",
                temperature: 0.7,
            });

            res.json({ result: completion.choices[0].message.content });
        } catch (error) {
            console.error("Error moon sync:", error);
            res.status(500).json({ error: error.message });
        }
    });
});
