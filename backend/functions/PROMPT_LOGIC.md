# Jungian Dream Interpretation Logic (v2.0)

**Last Updated:** February 2026
**File:** `backend/functions/index.js`

## Overview
The dream interpretation logic has been overhauled to act as a **Jungian Dream Analyst**. It prioritizes specifically curated scenarios from the dictionary but falls back to general Jungian knowledge if data is missing.

## Core Components

### 1. Data Injection (Pass 2)
The Cloud Function fetches symbol data from `dreamboatjournal.com/api/meaning/KEYWORD`.
**RULE Update**: Pass 1 now strictly extracts **TANGIBLE NOUNS** to avoid API 404s (e.g., "STAIRS" instead of "CLIMBING").

It creates a structured context block for the prompt:

```text
SEMBOL: SNAKE
{SEM_GIRIS}: ... (Basic Meaning / Definition)
{SEM_GOVDE}: ... (Psychological/Spiritual Depth)
{SEM_SENARYOLAR}: 
- Snake Bite: ...
- Golden Snake: ...
```

### 2. The Prompt Rules (Pass 3)
*   **Role:** Jungian Analyst (Unconscious, Shadows, Archetypes, Self).
*   **JSON Structure:**
    *   `title`: Engaging title.
    *   `definition`: Encyclopedic definition from `{SEM_GIRIS}`.
    *   `interpretation`: **STRICTLY 2 paragraphs** separated by `\n\n`.
    *   `cosmicAnalysis`: Formatted list with Emojis (🌑 🌓 🌕) and newlines for readability.
*   **Pattern Matching:**
    *   **IF** dream matches a `{SEM_SENARYOLAR}` entry -> Use that specific meaning (e.g. Stuck on Stairs -> Libido Stagnation).
    *   **IF** no match -> Use `{SEM_GOVDE}` (Psychological/Spiritual Body).
    *   **FALLBACK:** If no reference data exists -> Use general Jungian knowledge.
*   **Formatting:**
    *   Maximize readability (Newlines).
    *   **NO Technical Tags** (User never sees `{SEM...}`).
*   **Language:** Response is strictly in the detected language of the dream.

## Cosmic Analysis
The `cosmicAnalysis` is now formatted by the LLM to include Moon Phase emojis and list structure for better visual presentation in the app.

## Deployment
To deploy changes to this logic:
```bash
firebase deploy --only functions
```
