const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const admin = require("firebase-admin");
const { OpenAI } = require("openai");
const { enforceRateLimit } = require("./rateLimiter");

// dictionary import removed as we now use LLM knowledge + API for symbols

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

    try {
        // --- PASS 1: KEYWORD EXTRACTION (English Universal Keys) ---
        // Goal: Convert dream content into 1-3 English keywords for API lookup
        // e.g. "Koca bir yılan gördüm" -> ["SNAKE"]
        const extractionPrompt = `
        Analyze the dream and extract 1-3 dominant symbols.
        The dream may be in ANY language.
        
        RULES:
        1. EXTRACT ONLY **TANGIBLE NOUNS** (Objects, Animals, Places).
        2. DO NOT extract abstract concepts (e.g., "Fear", "Running").
        3. DO NOT extract verbs (e.g., "Chasing").
        4. CONVERT to **UNIVERSAL ENGLISH KEYWORDS** (Singular, Uppercase).
        
        Examples:
        - "I was running from a big dog" -> { "symbols": ["DOG"] } (Ignore "Running")
        - "Merdiven çıkıyordum ama yoruldum" -> { "symbols": ["STAIRS"] } (Ignore "Climbing", "Tired")
        - "Dişlerim dökülüyordu" -> { "symbols": ["TEETH"] }
        
        Output ONLY a valid JSON object with a "symbols" key.
        `;

        const extractionCompletion = await openai.chat.completions.create({
            model: "gpt-4o-mini",
            messages: [
                { role: "system", content: extractionPrompt },
                { role: "user", content: dreamText }
            ],
            response_format: { type: "json_object" },
            temperature: 0.1, // Lower temperature for precision
        });

        let keywords = [];
        try {
            const raw = JSON.parse(extractionCompletion.choices[0].message.content);
            if (Array.isArray(raw)) {
                keywords = raw;
            } else {
                keywords = raw.symbols || raw.keywords || [];
            }
            if (!Array.isArray(keywords)) keywords = [];
        } catch (e) {
            console.warn("Keyword extraction failed", e);
        }

        // --- PASS 1.5: KEYWORD INJECTION (Fail-safe) ---
        // Ensure critical symbols are present if they appear in text (bypassing LLM variance)
        const textLower = dreamText.toLowerCase();
        if (textLower.includes('merdiven') || textLower.includes('ladder') || textLower.includes('stair') || textLower.includes('basamak')) {
            if (!keywords.map(k => k.toLowerCase()).includes('ladder') && !keywords.map(k => k.toLowerCase()).includes('stairs')) {
                keywords.push('stairs');
                console.log("Injected 'stairs' keyword based on text match");
            }
        }

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

                // Content Quality Aliases (Hotfix)
                // Maps keywords with poor/templated content to their high-quality equivalents
                const aliases = {
                    'ladder': 'stairs',
                    'stair': 'stairs',
                    'steps': 'stairs',
                    'merdiven': 'stairs'
                };
                const finalKey = aliases[cleanKey] || cleanKey;

                const response = await fetch(`${apiBase}/${finalKey}`);
                if (!response.ok) return null;
                return await response.json();
            } catch (err) {
                console.error(`API Fetch Error for ${key}:`, err);
                return null;
            }
        });

        const results = await Promise.all(fetchPromises);

        results.forEach((data, index) => {
            if (data) {
                const key = keywords[index];

                // Construct Jungian Reference Data Block
                // {SEM_GIRIS}: Basic meaning
                // {SEM_GOVDE}: Psychological + Spiritual depth
                // {SEM_SENARYOLAR}: Scenarios

                let semGiris = data.meaning || data.symbolism || "Symbolic meaning unavailable.";

                let semGovde = "";
                if (data.interpretations) {
                    if (data.interpretations.psychological) semGovde += `Psikolojik: ${data.interpretations.psychological}\n`;
                    if (data.interpretations.spiritual) semGovde += `Spiritüel: ${data.interpretations.spiritual}\n`;
                }
                if (!semGovde && data.symbolism) semGovde = data.symbolism; // Fallback

                let semSenaryolar = "";
                if (data.scenarios && Array.isArray(data.scenarios)) {
                    semSenaryolar = data.scenarios.map(s => `- ${s.title}: ${s.description}`).join('\n');
                }

                const refBlock = `
SEMBOL: ${key.toUpperCase()}
{SEM_GIRIS}: ${semGiris}
{SEM_GOVDE}: ${semGovde}
{SEM_SENARYOLAR}:
${semSenaryolar}
`;
                contextBuffer.push(refBlock);

                if (data.cosmicAnalysis) {
                    cosmicAnalysisBuffer.push(data.cosmicAnalysis);
                }
            }
        });

        const dictionaryContext = contextBuffer.length > 0
            ? `\n### [REFERANS VERİLERİ] (Grounding Data)\n${contextBuffer.join('\n\n')}`
            : "";

        // Combine Cosmic Analysis (if any)
        let finalCosmicAnalysis = cosmicAnalysisBuffer.length > 0
            ? cosmicAnalysisBuffer.join("\n\n")
            : null;

        console.log("Dictionary Context length:", dictionaryContext.length);

        // --- PASS 2.5: EXPLICIT LANGUAGE DETECTION ---
        const langDetectCompletion = await openai.chat.completions.create({
            model: "gpt-4o-mini",
            messages: [
                { role: "system", content: "Detect the language of the following text. Respond with ONLY the language name in English (e.g., 'English', 'Turkish', 'Spanish', 'German', 'Portuguese', 'Dutch', etc.). Nothing else." },
                { role: "user", content: dreamText }
            ],
            temperature: 0,
            max_tokens: 20
        });

        const detectedLanguage = langDetectCompletion.choices[0].message.content.trim();
        console.log("Detected dream language:", detectedLanguage);

        // --- PASS 3: INTERPRETATION (Synthesize) ---
        const systemPrompt = `
### ROL VE AMACIN
Sen DreamBoat uygulamasının uzman "Jungian Rüya Analisti"sin. Görevin, kullanıcının gördüğü rüyayı analiz etmektir.
Öncelikle sana verilen **[REFERANS VERİLERİ]**ni temel almalısın.

Referans verisi varsa, analizini o sembolün derin psikolojik anlamı üzerine kur.
Özellikle "Merdiven" gibi "tırmanma/yükselme" temalı rüyalarda, eğer kullanıcı "çıkamıyorsa" veya "takılı kalıyorsa", bunu Jungian "Libido'nun (Yaşam Enerjisi) yerinde sayması" veya "Yanlış yere kanalize edilmiş çaba" olarak yorumla.

${dictionaryContext}

### KULLANICI RÜYASI
"${dreamText}"

### ANALİZ KURALLARI (Adım Adım Uygula)
1. **Veri Kaynağı Kontrolü:** 
   - EĞER **[REFERANS VERİLERİ]** varsa: Kullanıcının rüya anlatısını **{SEM_SENARYOLAR}** ile karşılaştır. Örtüşürse oradan, örtüşmezse **{SEM_GOVDE}** üzerinden ilerle. sembolün "Ansiklopedik Tanımını" (**{SEM_GIRIS}**) JSON'daki 'definition' alanına koy.
   - EĞER **[REFERANS VERİLERİ]** YOKSA (Boşsa): Kendi Jungian bilgi tabanını kullan.

2. **Yorumlama Tarzı:**
   - Sembolün "Bilinçdışı"ndan gelen bir mesaj olduğunu hissettir.
   - Durumu bir "İçsel Dönüşüm" veya "Yüzleşme" fırsatı olarak çerçevele.
   - Eğer rüyada "ilerleyememe, düşme, kaçamama" varsa; bunu dışsal bir başarısızlık değil, "içeriye/derine bakma çağrısı" olarak yorumla.

3. **Uzunluk ve Yapı (KRİTİK):**
   - **definition:** Sembolün kısa, öz, ansiklopedik tanımı. (Max 1-2 cümle).
   - **interpretation:** Analiz metni. OKUNABİLİRLİK İÇİN MUTLAKA **İKİ PARAGRAF** OLMALIDIR. İki paragrafın arasına \`\\n\\n\` (çift satır sonu) koyarak ayır.
   - Toplam metin uzunluğu (interpretation) **maksimum 100 kelime**.

4. **Ton ve Üslup:**
   - Mistik, derinlikli, ancak modern ve anlaşılır.
   - Asla yargılayıcı olma.
   - **Markdown formatı (kalın, italik) KULLANMA.** Sadece paragraf ayırmak için satır sonu kullan.
   - Teknik etiketleri ({SEM_...}) kullanıcıya gösterme.

5. **DİL:**
   - Tüm çıktıyı **${detectedLanguage}** dilinde ver.

6. **KOZMİK ANALİZ (ZORUNLU ÇEVİRİ):**
   - Aşağıdaki "KOZMİK ANALİZ METNİ" bölümündeki metni **${detectedLanguage}** diline çevir.
   - **ASLA** orijinal dilde (İngilizce) bırakma.
   - **FORMAT:** Metni düz bir paragraf olarak YAZMA.
   - Her bir Ay evresini veya maddeyi **AYRI BİR SATIRA** koy.
   - Ay evreleri için **EMOJİ** kullan (🌑 Yeni Ay, 🌓 İlk Dördün, 🌕 Dolunay, 🌗 Son Dördün vb.).
   - Okuyucunun gözünde canlanacak şık bir liste gibi durmalı.
   - Eğer kaynak metinde ay evresi yoksa bile, metni mantıklı parçalara bölerek alt alta yaz.

### ÇIKTI FORMATI (JSON)
Yanıtını sadece ve sadece aşağıdaki JSON formatında ver:
{
    "title": "Kısa, ilgi çekici başlık (${detectedLanguage})",
    "definition": "Sembolün öz tanımı (${detectedLanguage}) - {SEM_GIRIS} verisinden al",
    "interpretation": "Analiz metni. İKİ PARAGRAF. Arada \\n\\n boşluğu ŞART. (${detectedLanguage})",
    "cosmicAnalysis": "Kozmik analiz (Emoji ve Satır Listesi Formatında) (${detectedLanguage}) veya null"
}

### KOZMİK ANALİZ METNİ (Çevrilecek ve Formatlanacak):
"${finalCosmicAnalysis || ''}"
`;


        const completion = await openai.chat.completions.create({
            model: "gpt-4o-mini",
            messages: [
                { role: "system", content: systemPrompt },
                { role: "user", content: `Interpret this dream in ${detectedLanguage}.` }
            ],
            response_format: { type: "json_object" },
            temperature: 0.7,
        });

        const responseContent = JSON.parse(completion.choices[0].message.content);

        const title = responseContent.title || "Dream Analysis";
        const definition = responseContent.definition || "";
        let interpretation = responseContent.interpretation || "Interpretation unavailable.";
        let cosmicAnalysis = responseContent.cosmicAnalysis || "";

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

    try {
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

    try {
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
        console.error("Error moon sync:", error);
        throw new HttpsError('internal', error.message);
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

    console.log(`generateDreamImage called.uid =\${ uid }, dreamId =\${ dreamId }, isTrial =\${ isTrial }, isDebug =\${ isDebug } `);

    if (!dreamText || !dreamId) {
        throw new HttpsError('invalid-argument', 'Missing dreamText or dreamId');
    }

    // Get Storage bucket (explicit bucket name for Firebase project)
    // [PRE-FLIGHT CHECK] Validate storage BEFORE expensive OpenAI calls
    let bucket;
    try {
        bucket = admin.storage().bucket('dream-boat-app.firebasestorage.app');
        console.log(`Storage bucket initialized: \${ bucket.name } `);

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

    const filePath = `dream_images /\${ uid }/\${dreamId}.png`;
    const file = bucket.file(filePath);

    // [IDEMPOTENCY CHECK]
    // If image exists, return it immediately. Do NOT consume limit.
    try {
        const [exists] = await file.exists();
        if (exists) {
            console.log(`Image already exists for dream \${dreamId}. Returning cached result.`);
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
    const userStatsRef = db.doc(`users/\${uid}/stats/limits`);

    // Get current UTC Date Key
    const now = new Date();
    const dateKey = now.toISOString().split('T')[0]; // "2026-02-01"

    const statsSnap = await userStatsRef.get();
    const stats = statsSnap.data() || {};

    // [DEBUG BYPASS]
    if (isDebug === true) {
        console.log(`[DEBUG BYPASS] Skipping rate limits for user \${uid}`);
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
                { role: "user", content: `Dream: \${dreamText}` }
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
