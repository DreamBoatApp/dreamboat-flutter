const fs = require('fs');
const path = require('path');

// Read both ARB files
const trPath = path.join(__dirname, 'lib', 'l10n', 'app_tr.arb');
const enPath = path.join(__dirname, 'lib', 'l10n', 'app_en.arb');

const trContent = JSON.parse(fs.readFileSync(trPath, 'utf-8'));
const enContent = JSON.parse(fs.readFileSync(enPath, 'utf-8'));

// Get keys (excluding metadata keys starting with @@)
const trKeys = Object.keys(trContent).filter(k => !k.startsWith('@@'));
const enKeys = Object.keys(enContent).filter(k => !k.startsWith('@@'));

// Find missing keys in English
const missingInEn = trKeys.filter(k => !enKeys.includes(k));

console.log(`\n=== ANALYSIS ===`);
console.log(`Turkish keys: ${trKeys.length}`);
console.log(`English keys: ${enKeys.length}`);
console.log(`Missing in English: ${missingInEn.length}\n`);

if (missingInEn.length > 0) {
  console.log('Missing keys:');
  console.log(JSON.stringify(missingInEn, null, 2));
  
  // Output Turkish values for translation
  console.log('\n=== TURKISH VALUES TO TRANSLATE ===\n');
  const toTranslate = {};
  missingInEn.forEach(key => {
    toTranslate[key] = trContent[key];
  });
  console.log(JSON.stringify(toTranslate, null, 2));
}
