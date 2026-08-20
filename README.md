<div align="center">

<img src="./frontend/src/assets/logo2.png" alt="LeafCompass Logo" width="120"/>

# 🌿 LeafCompass

### Smart Farming, Powered by AI

**LeafCompass** is an intelligent agricultural assistant that empowers farmers with data-driven insights — diagnose plant diseases, predict crop yields, get tailored recommendations, and chat with an AI agronomist. All in one platform.

[![Live Demo](https://img.shields.io/badge/Live%20Demo-Vercel-000000?style=for-the-badge&logo=vercel&logoColor=white)](https://leafcompass.vercel.app/)
[![Backend API](https://img.shields.io/badge/Backend%20API-HuggingFace-FFD21E?style=for-the-badge&logo=huggingface&logoColor=black)](https://jain-mayukh-lc-api.hf.space/docs)
[![Flutter](https://img.shields.io/badge/Flutter-Mobile-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](./LICENSE)

</div>

---

## 🔗 Live Links

| Platform | URL |
|---|---|
| 🌐 Web App (Vercel) | https://leafcompass.vercel.app/ |

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Tech Stack](#️-tech-stack)
- [Architecture](#️-architecture)
- [Project Structure](#-project-structure)
- [Local Setup](#️-local-setup)
- [AI Models](#-ai-models)
- [API Reference](#-api-reference)
- [Environment Variables](#-environment-variables)
- [Deployment](#-deployment)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🌱 Overview

LeafCompass bridges the gap between modern AI and everyday farming. Whether you're a farmer in the field or an agronomist in the lab, LeafCompass delivers instant, accurate, ML-powered insights through:

- A **React web app** deployed on Vercel
- A **Flutter mobile app** for Android/iOS
- A **FastAPI backend** hosted on Hugging Face Spaces (Dockerized)

---

## ✨ Features

### 🍂 Plant Disease Detection
- **Input:** Upload a crop leaf image
- **Model:** Custom CNN built with TensorFlow/Keras
- **Output:** Disease name + confidence score

### 🌾 Crop Yield Prediction
- **Input:** Rainfall, Temperature, Soil Type, Region, Weather Condition, etc.
- **Model:** Random Forest Regressor (Scikit-Learn)
- **Output:** Predicted yield in kg/ha

### 🌱 Crop Recommendation
- **Input:** Soil N-P-K values, pH, Humidity, Rainfall, State
- **Model:** Random Forest Classifier
- **Output:** Most suitable crop for your conditions

### 🧪 Fertilizer Recommendation
- **Input:** Soil stats, Crop type, Moisture levels
- **Model:** XGBoost / Random Forest Classifier
- **Output:** Recommended fertilizer type

### 🤖 AgroBot (AI Chat)
- **Engine:** `deepseek-ai/DeepSeek-V3.2` via Hugging Face Inference API
- **Function:** Answers real-time farming questions in plain language

---

## 🛠️ Tech Stack

### Web Frontend (React)
| Tool | Purpose |
|---|---|
| React.js | UI framework |
| Tailwind CSS | Styling |
| Lucide React | Icons |
| React Router DOM | Client-side routing |
| Axios | HTTP client |

### Mobile Frontend (Flutter)
| Tool | Purpose |
|---|---|
| Flutter 3.x + Material 3 | UI framework |
| go_router | Declarative navigation |
| google_fonts | Inter typeface |
| flutter_animate | Micro-animations |
| image_picker | Camera & gallery access |

### Backend (Python / FastAPI)
| Tool | Purpose |
|---|---|
| FastAPI + Uvicorn | High-performance async API |
| TensorFlow / Keras | Plant disease CNN |
| Scikit-learn / Joblib | Yield, Crop & Fertilizer models |
| Pandas / NumPy | Data processing |
| Hugging Face `InferenceClient` | DeepSeek V3.2 chat |
| Pillow | Server-side image preprocessing |
| Docker | Containerised deployment on HF Spaces |

---

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────────────┐
│                      Client Layer                        │
│  ┌─────────────────────┐   ┌──────────────────────────┐  │
│  │  React Web App      │   │  Flutter Mobile App      │  │
│  │  (Vercel)           │   │  (Android / iOS)         │  │
│  └──────────┬──────────┘   └───────────┬──────────────┘  │
└─────────────┼────────────────────────────┼───────────────┘
              │           REST API          │
              ▼                             ▼
┌──────────────────────────────────────────────────────────┐
│          FastAPI Backend (Hugging Face Spaces)           │
│  ┌────────────┐  ┌──────────────────┐  ┌──────────────┐  │
│  │ TensorFlow │  │  scikit-learn /  │  │ HuggingFace  │  │
│  │  Disease   │  │  XGBoost Models  │  │ DeepSeek V3  │  │
│  │    CNN     │  │ Yield/Crop/Fert. │  │  (AgroBot)   │  │
│  └────────────┘  └──────────────────┘  └──────────────┘  │
└──────────────────────────────────────────────────────────┘
```

---

## 📁 Project Structure

```
Leaf-Compass/
├── backend/
│   ├── main.py                  # FastAPI entry point & all endpoints
│   ├── requirements.txt         # Python dependencies
│   ├── Dockerfile               # Docker config for Hugging Face Spaces
│   ├── README.md                # Backend-specific notes
│   └── models/                  # Trained ML model files
│       ├── plant_disease_prediction_model.h5
│       ├── class_indices.json
│       ├── yield_prediction_model.pkl
│       ├── crop_recommendation_model.pkl
│       └── fertilizer_recommendation_model.pkl
│
├── frontend/                    # React web application
│   ├── src/
│   │   ├── components/          # Reusable UI (Header, Footer, Forms)
│   │   ├── pages/               # Page views (Home, Disease, Yield, etc.)
│   │   ├── services/            # API.js — Axios configuration
│   │   ├── assets/              # Images, icons, logo
│   │   └── App.js               # Main router
│   ├── tailwind.config.js
│   └── package.json
│
├── flutter_frontend/            # Flutter mobile application
│   ├── lib/
│   │   ├── main.dart            # App entry, theme & routing
│   │   ├── screens/
│   │   │   ├── home_screen.dart
│   │   │   ├── disease_screen.dart
│   │   │   ├── yield_screen.dart
│   │   │   ├── crop_screen.dart
│   │   │   ├── fertilizer_screen.dart
│   │   │   └── chat_screen.dart
│   │   ├── services/
│   │   │   └── api_service.dart
│   │   └── models/
│   │       └── chat_message.dart
│   └── android/
│
└── model training/              # Jupyter notebooks & training scripts
    ├── Crop_Disease_Detection/
    ├── Crop_prediction_model/
    ├── Fertilizer_recommendation/
    └── Yield_prediction_Model/
```

---

## ⚙️ Local Setup

### Prerequisites

| Tool | Version |
|---|---|
| Node.js & npm | ≥ 18 |
| Python | ≥ 3.9 |
| Flutter SDK | ≥ 3.0 |
| Git | Latest |

---

### Step 1 — Clone the Repository

```bash
git clone https://github.com/your-username/leaf-compass.git
cd leaf-compass
```

---

### Step 2 — Backend Setup

```bash
cd backend

# Create and activate a virtual environment
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Add your Hugging Face token to a .env file
echo "API=hf_your_token_here" > .env

# Start the server
python main.py
```

> Server runs at `http://localhost:8000` — visit `/docs` for the Swagger UI.

---

### Step 3 — Web Frontend Setup

Open a new terminal:

```bash
cd frontend

npm install
npm start
```

> App opens at `http://localhost:3000`.

---

### Step 4 — Flutter App Setup (Optional)

```bash
cd flutter_frontend

flutter pub get

# For Android emulator, set base URL to http://10.0.2.2:8000
# in lib/services/api_service.dart

flutter run
```

---

## 🧠 AI Models

| Feature | Algorithm | Input | Accuracy |
|---|---|---|---|
| 🍂 Disease Detection | CNN (TensorFlow/Keras) | Leaf image 224×224 | ~92% |
| 🌾 Yield Prediction | Random Forest Regressor | Weather & soil data | ~88% R² |
| 🌱 Crop Recommendation | Random Forest Classifier | NPK, pH, rainfall | ~99% |
| 🧪 Fertilizer Recommendation | XGBoost / Random Forest | Soil & crop data | ~95% |
| 🤖 AgroBot | DeepSeek-V3.2 (HF API) | Natural language | — |

Training notebooks for all models are in the `model training/` directory.

---

## 📡 API Reference

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/` | Health check |
| `POST` | `/predict-disease` | Leaf image upload → disease + confidence |
| `POST` | `/predict-yield` | Weather/soil JSON → yield in kg/ha |
| `POST` | `/recommend-crop` | NPK/pH/climate JSON → recommended crop |
| `POST` | `/recommend-fertilizer` | Soil/crop JSON → recommended fertilizer |
| `POST` | `/chat` | `{ "message": "..." }` → AgroBot reply |

> Full interactive docs: **https://jain-mayukh-lc-api.hf.space/docs**

---

## 🔑 Environment Variables

Create a `.env` file inside the `backend/` directory:

```env
# Hugging Face API token for DeepSeek V3.2 (AgroBot)
API=hf_your_hugging_face_token_here
```

For **Hugging Face Spaces** deployment, set this in:
`Settings → Variables and Secrets`

---

## 🚀 Deployment

### Backend — Hugging Face Spaces (Docker)

1. Create a new Space on [Hugging Face](https://huggingface.co/spaces) with **SDK: Docker**
2. Push the contents of the `backend/` folder to the Space repo
3. Add your `API` token under **Settings → Variables and Secrets**
4. The Space will auto-build and deploy via the `Dockerfile`

### Web Frontend — Vercel

1. Push the `frontend/` folder to a GitHub repository
2. Import the repo into [Vercel](https://vercel.com)
3. Set the **Root Directory** to `frontend`
4. Click **Deploy** ✅

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/your-feature`
3. **Commit** your changes: `git commit -m 'feat: describe your change'`
4. **Push** to the branch: `git push origin feature/your-feature`
5. **Open** a Pull Request

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](./LICENSE) file for details.

---

<div align="center">

Made with 💚 for the Farming Community

</div>
