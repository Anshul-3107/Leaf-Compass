<div align="center">
# 🌿 LeafCompass
 
### Smart Farming, Powered by AI
 
**LeafCompass** is an intelligent agricultural assistant that empowers farmers with data-driven insights — diagnose plant diseases, predict crop yields, get tailored recommendations, and chat with an AI agronomist. All in one unified mobile platform.
 
[![Flutter](https://img.shields.io/badge/Flutter-Mobile-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![FastAPI](https://img.shields.io/badge/Backend-FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)
[![PyTorch](https://img.shields.io/badge/ML-PyTorch-EE4C2C?style=for-the-badge&logo=pytorch&logoColor=white)](https://pytorch.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](./LICENSE)
 
</div>
---
 
## 📖 Table of Contents
 
- [Overview](#-overview)
- [Features](#-features)
- [Tech Stack](#️-tech-stack)
- [Project Structure](#-project-structure)
- [Local Setup](#️-local-setup)
- [AI Models](#-ai-models)
- [API Reference](#-api-reference)
- [Environment Variables](#-environment-variables)
- [Deployment](#-deployment)
- [License](#-license)
---
 
## 🌱 Overview
 
LeafCompass bridges the gap between modern AI and everyday farming. Whether you're a farmer in the field or an agronomist in the lab, LeafCompass delivers instant, ML-powered insights through:
 
- A **Flutter mobile app** — clean, responsive UI across Android/iOS
- A **FastAPI backend** — serves four ML models plus an LLM-powered chat assistant, deployable via Docker to Hugging Face Spaces, Render, or any container host
---
 
## ✨ Features
 
### 🍂 Plant Disease Detection
- **Input:** Upload a crop leaf image
- **Model:** Custom CNN built with **PyTorch**, trained from scratch on the PlantVillage dataset (38 disease classes, ~54K images)
- **Output:** Disease name + confidence score
### 🌾 Crop Yield Prediction
- **Input:** Rainfall, temperature, soil type, region, weather condition, fertilizer/irrigation use, days to harvest
- **Model:** Random Forest Regressor (Scikit-learn)
- **Output:** Predicted yield (tons/hectare)
### 🌱 Crop Recommendation
- **Input:** Soil N-P-K values, pH, humidity, rainfall, state
- **Model:** Random Forest Classifier (Scikit-learn)
- **Output:** Most suitable crop for the given conditions
### 🧪 Fertilizer Recommendation
- **Input:** Soil stats, crop type, moisture level
- **Model:** Random Forest Classifier (Scikit-learn)
- **Output:** Recommended fertilizer type
### 🤖 AgroBot (AI Chat)
- **Engine:** DeepSeek model via Hugging Face `InferenceClient`
- **Function:** Answers real-time farming questions in plain language
---
 
## 🛠️ Tech Stack
 
### Mobile / Client (Flutter)
| Tool | Purpose |
|---|---|
| Flutter / Dart | Cross-platform UI framework |
| Dio | Unified REST API networking client (JSON + multipart file uploads) |
| Material 3 | Modern UI components & styling |
| go_router | Declarative navigation |
| provider | State management |
| image_picker | Capturing/selecting leaf photos for disease detection |
 
### Backend (Python / FastAPI)
| Tool | Purpose |
|---|---|
| FastAPI + Uvicorn | Async API server |
| PyTorch + torchvision | Plant disease CNN — training and inference |
| Scikit-learn + Joblib | Yield, crop, and fertilizer prediction models |
| Pandas / NumPy | Data processing |
| Hugging Face `huggingface_hub` (`InferenceClient`) | AgroBot chat via DeepSeek |
| Pillow | Server-side image preprocessing |
| Docker | Containerized deployment (Hugging Face Spaces / Render) |
 
---
 
## 📁 Project Structure
 
```
Leaf-Compass/
├── backend/                    # FastAPI backend
│   ├── main.py                 # All API endpoints + model loading
│   ├── requirements.txt        # Pinned Python dependencies
│   ├── Dockerfile              # Production container definition
│   ├── .env                    # Local secrets (gitignored, not committed)
│   └── models/                 # Trained model files
│       ├── plant_disease_cnn.py           # Shared PyTorch model class
│       ├── crop_recommendation_model.pkl  # ✅ committed
│       ├── fertilizer_recommendation_model.pkl  # ✅ committed
│       ├── class_indices.json             # ✅ committed
│       ├── plant_disease_prediction_model.pt   # ⚠️ not committed (large file)
│       └── yield_prediction_model.pkl          # ⚠️ not committed (large file)
├── flutter_frontend/            # Flutter mobile app
│   └── lib/
│       ├── screens/             # One screen per feature
│       └── services/
│           └── api_service.dart # All backend API calls (Dio)
└── model training/              # Training scripts + notebooks (not part of the deployed app)
    ├── Crop_Disease_Detection/
    │   ├── train_disease_model.py                 # PyTorch training script
    │   └── ..._TENSORFLOW_DEPRECATED.ipynb        # Original notebook (kept for reference)
    ├── Yield_prediction_Model/
    │   └── train_yield.py
    ├── Crop_prediction_model/
    └── Fertilizer_recommendation/
```
 
---
 
## ⚙️ Local Setup
 
### Prerequisites
- Python 3.11
- Flutter SDK
- A Hugging Face account + API token (for AgroBot chat)
### 1. Clone the repo
```bash
git clone https://github.com/Anshul-3107/Leaf-Compass.git
cd Leaf-Compass
```
 
### 2. Backend setup
```bash
cd backend
python -m venv venv
.\venv\Scripts\Activate.ps1    # Windows
pip install -r requirements.txt
```
 
Create a `.env` file in `backend/`:
```
API=<your_huggingface_token>
```
 
> [!IMPORTANT]
> Two model files are **not included in this repository** due to their size (~360MB combined):
> `models/plant_disease_prediction_model.pt` and `models/yield_prediction_model.pkl`.
> See [AI Models](#-ai-models) below for how to obtain or train them.
 
Run the backend:
```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```
Visit `http://localhost:8000/docs` for interactive API docs.
 
### 3. Flutter setup
```bash
cd flutter_frontend
flutter pub get
flutter run
```
By default, the app points at `http://10.0.2.2:8000` (Android emulator loopback). To point at a different backend:
```bash
flutter run --dart-define=API_BASE_URL=https://your-deployed-backend-url
```
 
---
 
## 🧠 AI Models
 
| Model | Framework | Status | Training script |
|---|---|---|---|
| Crop recommendation | Scikit-learn | ✅ Included in repo | `model training/Crop_prediction_model/` |
| Fertilizer recommendation | Scikit-learn | ✅ Included in repo | `model training/Fertilizer_recommendation/` |
| Plant disease detection | PyTorch (custom CNN) | ⚠️ Train locally or download separately | `model training/Crop_Disease_Detection/train_disease_model.py` |
| Yield prediction | Scikit-learn (Random Forest) | ⚠️ Train locally or download separately | `model training/Yield_prediction_Model/train_yield.py` |
 
To train the two larger models yourself:
```bash
# Yield model (CPU, a few minutes)
cd "model training/Yield_prediction_Model"
python train_yield.py
 
# Disease detection model (GPU strongly recommended — see script header for details)
cd "model training/Crop_Disease_Detection"
python train_disease_model.py
```
The disease detection script downloads the [PlantVillage dataset](https://www.kaggle.com/datasets/abdallahalidev/plantvillage-dataset) via the Kaggle API — requires a `~/.kaggle/kaggle.json` credentials file (see [Kaggle's API docs](https://www.kaggle.com/docs/api)).
 
---
 
## 🔌 API Reference
 
| Method | Path | Description |
|--------|------|-------------|
| GET | `/` | Health check |
| POST | `/recommend-crop` | Crop recommendation |
| POST | `/recommend-fertilizer` | Fertilizer recommendation |
| POST | `/predict-disease` | Plant disease detection (multipart image upload) |
| POST | `/predict-yield` | Crop yield prediction |
| POST | `/chat` | AgroBot chat (DeepSeek via Hugging Face) |
 
Full interactive documentation is available at `/docs` on any running instance (local or deployed).
 
---
 
## 🔐 Environment Variables
 
| Variable | Where | Description |
|---|---|---|
| `API` | `backend/.env` (local) or Space/Render secrets (deployed) | Hugging Face API token, used for AgroBot chat inference |
 
> [!WARNING]
> Never commit `.env` or any real API token to git. `.env` is already listed in `.gitignore`.
 
---
 
## 🚀 Deployment
 
The backend is a self-contained Docker app (`backend/Dockerfile`) and can be deployed to:
 
- **Hugging Face Spaces** (Docker SDK) — recommended, since it natively supports large model files via Git LFS
- **Render** (Docker-based web service) — the Dockerfile reads `$PORT` at runtime with a fallback of `7860`
See [`backend/README.md`](./backend/README.md) for deployment-specific notes.
 
The Flutter app is built as a standard release APK/IPA, pointed at the deployed backend URL via `--dart-define=API_BASE_URL=...` at build time.
 
---
 
## 📄 License
 
MIT — see [`LICENSE`](./LICENSE) for details.
 