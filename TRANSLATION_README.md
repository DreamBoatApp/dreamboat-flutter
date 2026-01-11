# DreamBoat Translation System

## Quick Start

### To update/sync all language translations:
```bash
node translate_workflow.js
```

This will:
- Compare Turkish (master) with English
- Auto-translate missing keys using OpenAI GPT-4
- Update `app_en.arb` automatically
- **Never touch Turkish** (protected)

---

## Setup (Optional - for AI translation)

Set your OpenAI API key to enable automated translations:
```bash
set OPENAI_API_KEY=sk-your-openai-key-here
```

Without API key, script will mark translations as `[TRANSLATE]` for manual work.

---

## Adding a New Language

1. Edit `translate_workflow.js`, line 17:
```javascript
const TARGET_LANGS = ['en', 'fr']; // Add 'fr' for French
```

2. Run workflow:
```bash
node translate_workflow.js
```

3. Update lib/main.dart:
```dart
supportedLocales: const [
  Locale('tr'),
  Locale('en'),
  Locale('fr'), // Add this
],
```

4. Rebuild:
```bash
flutter pub get
```

---

## Rules

✅ **DO:** Always edit `lib/l10n/app_tr.arb` first (master)  
✅ **DO:** Run `translate_workflow.js` after changes  
❌ **DON'T:** Manually edit `app_en.arb` (gets overwritten)  
❌ **DON'T:** Ever modify automation to touch Turkish ARB  

---

**Turkish is the source of truth. Everything translates FROM Turkish.**

For full documentation, see: `translation_guide.md` in the brain directory.
