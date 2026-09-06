---
title: Leaf Compass API
emoji: 🌿
colorFrom: green
colorTo: yellow
sdk: docker
pinned: false
app_port: 7860
---

# Leaf Compass Backend

This is the FastAPI backend for LeafCompass, built with Python and served via Uvicorn inside Docker.

## Setup

### 1. Install dependencies

```bash
pip install -r requirements.txt
```

### 2. Environment variables

Create a `.env` file in this directory (it is gitignored):

```
API=<your_huggingface_token>
```

### 3. Required model files (not in git)

> [!IMPORTANT]
> The following two model files are **excluded from the repository** (via `.gitignore`)
> because of their large size. You must **download and place them manually** in
> `backend/models/` before starting the server.

| File | Description | Where to get it |
|------|-------------|-----------------|
| `models/plant_disease_prediction_model.pt` | PyTorch CNN state dict for plant disease classification (38 classes) | Train locally with `train_disease_model.py`, or download from: **[your model host — fill this in]** |
| `models/yield_prediction_model.pkl` | Scikit-learn model for crop yield prediction | Download from: **[your model host — fill this in]** |

The following model files **are** committed to the repo and need no manual action:

- `models/crop_recommendation_model.pkl`
- `models/fertilizer_recommendation_model.pkl`
- `models/class_indices.json`

### 4. Run locally

```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

## Deployment

### Hugging Face Spaces (Docker)

Push this `backend/` directory to a Hugging Face Space with SDK set to `docker`.
The container binds to port 7860 by default (or `$PORT` if set).

### Render

Set the `PORT` environment variable in your Render service settings if needed.
The app reads `$PORT` at runtime with a fallback of `7860`.

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/` | Health check |
| POST | `/predict-disease` | Plant disease detection (image upload) |
| POST | `/predict-yield` | Crop yield prediction |
| POST | `/recommend-crop` | Crop recommendation |
| POST | `/recommend-fertilizer` | Fertilizer recommendation |
| POST | `/chat` | AgroBot chat (DeepSeek via HuggingFace) |