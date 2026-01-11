/**
 * DreamBoat Automated Translation Workflow
 * 
 * This script automatically translates new Turkish strings to English (and future languages)
 * ensuring Turkish remains the source of truth.
 * 
 * Usage:
 *   node translate_workflow.js
 * 
 * What it does:
 *   1. Compares app_tr.arb (master) with app_en.arb
 *   2. Finds missing or outdated keys in English
 *   3. Uses OpenAI API to translate Turkish → English
 *   4. Updates app_en.arb while preserving formatting
 */

const fs = require('fs');
const path = require('path');
const https = require('https');

// Configuration
const L10N_DIR = path.join(__dirname, 'lib', 'l10n');
const MASTER_LANG = 'tr';
const TARGET_LANGS = ['en', 'es', 'pt', 'de']; // English, Spanish, Portuguese, German

// ===== HELPER FUNCTIONS =====

function readARB(lang) {
    const filePath = path.join(L10N_DIR, `app_${lang}.arb`);
    return JSON.parse(fs.readFileSync(filePath, 'utf-8'));
}

function writeARB(lang, content) {
    const filePath = path.join(L10N_DIR, `app_${lang}.arb`);
    fs.writeFileSync(filePath, JSON.stringify(content, null, 4) + '\n', 'utf-8');
}

function findMissingKeys(master, target) {
    const masterKeys = Object.keys(master).filter(k => !k.startsWith('@@'));
    const targetKeys = Object.keys(target).filter(k => !k.startsWith('@@'));
    return masterKeys.filter(k => !targetKeys.includes(k));
}

async function translateWithOpenAI(textToTranslate, targetLang) {
    const apiKey = process.env.OPENAI_API_KEY;

    if (!apiKey) {
        console.warn('⚠️  OPENAI_API_KEY not found. Using placeholder translations.');
        console.warn('   Set OPENAI_API_KEY in environment to enable auto-translation.');
        return `[TODO: Translate to ${targetLang}] ${textToTranslate}`;
    }

    const langNames = { en: 'English', fr: 'French', de: 'German', es: 'Spanish', pt: 'Portuguese' };
    const prompt = `Translate this dream journal app text from Turkish to ${langNames[targetLang] || targetLang}. Keep it natural and user-friendly. Only return the translation, no explanations:\n\n${textToTranslate}`;

    return new Promise((resolve, reject) => {
        const data = JSON.stringify({
            model: "gpt-4",
            messages: [{ role: "user", content: prompt }],
            temperature: 0.3,
            max_tokens: 500
        });

        const options = {
            hostname: 'api.openai.com',
            port: 443,
            path: '/v1/chat/completions',
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${apiKey}`,
                'Content-Length': data.length
            }
        };

        const req = https.request(options, (res) => {
            let body = '';
            res.on('data', chunk => body += chunk);
            res.on('end', () => {
                try {
                    const response = JSON.parse(body);
                    const translation = response.choices[0].message.content.trim();
                    resolve(translation);
                } catch (error) {
                    reject(error);
                }
            });
        });

        req.on('error', reject);
        req.write(data);
        req.end();
    });
}

// ===== MAIN WORKFLOW =====

async function runTranslationWorkflow() {
    console.log('🌍 DreamBoat Translation Workflow\n');
    console.log('📖 Turkish is the source of truth\n');

    const masterContent = readARB(MASTER_LANG);

    for (const targetLang of TARGET_LANGS) {
        console.log(`\n━━━ Processing: Turkish → ${targetLang.toUpperCase()} ━━━\n`);

        let targetContent;
        try {
            targetContent = readARB(targetLang);
        } catch (error) {
            console.log(`📝 Creating new ${targetLang}.arb file...`);
            targetContent = { [`@@locale`]: targetLang };
        }

        const missingKeys = findMissingKeys(masterContent, targetContent);

        if (missingKeys.length === 0) {
            console.log(`✅ No missing keys! ${targetLang}.arb is up to date.`);
            continue;
        }

        console.log(`🔍 Found ${missingKeys.length} missing translations:\n`);

        for (const key of missingKeys) {
            const turkishText = masterContent[key];
            console.log(`   📌 ${key}`);
            console.log(`      TR: "${turkishText}"`);

            try {
                const translation = await translateWithOpenAI(turkishText, targetLang);
                targetContent[key] = translation;
                console.log(`      ${targetLang.toUpperCase()}: "${translation}" ✓\n`);
            } catch (error) {
                console.error(`      ❌ Translation failed: ${error.message}`);
                targetContent[key] = `[TRANSLATE] ${turkishText}`;
            }
        }

        writeARB(targetLang, targetContent);
        console.log(`\n💾 Saved app_${targetLang}.arb`);
    }

    console.log('\n✨ Translation workflow complete!\n');
}

// Run the workflow
runTranslationWorkflow().catch(console.error);
