---
description: DreamBoat project structure - mobile app and backend locations
---

# DreamBoat Project Structure

DreamBoat consists of two separate repositories/directories:

## 1. Mobile App (Flutter)
- **Path**: `c:/Users/guney/.gemini/antigravity/playground/shimmering-singularity/dream_boat_mobile`
- **Repo**: Public Flutter app
- **Tech**: Flutter, Dart, Hive, Firebase

## 2. Backend (Firebase Cloud Functions)
- **Path**: `c:/Users/guney/.gemini/antigravity/playground/shimmering-singularity/dreamboat-backend`
- **Repo**: Private GitHub repo (`DreamBoatApp/dreamboat-backend`)
- **Tech**: Node.js 22, Firebase Cloud Functions v2, Gemini 2.5 Flash (via `@google/genai` + Vertex AI), OpenAI (ONLY for DALL-E 3 image generation)
- **Deploy**: `firebase deploy --only functions` from `dreamboat-backend/functions/`

## 3. Web (Next.js)
- **Path**: `c:/Users/guney/.gemini/antigravity/scratch/dreamboat_journal_web`
- **Site**: dreamboatjournal.com

## Important Notes
- When the user mentions DreamBoat or `dream_boat_mobile`, **always also consider the backend** at `dreamboat-backend/`
- The backend uses **Gemini** (not OpenAI) for all text generation. OpenAI is only used for DALL-E 3 image generation.
- Never deploy from a stale local copy — always `git pull` first to ensure code is current.
