<div align="center">

# 🌿 LeafCompass

**An AI-powered agricultural intelligence platform** — detect crop diseases, predict yields, get smart crop & fertilizer recommendations, and chat with an agronomy assistant. All in one app.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-009688?logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)
[![TensorFlow](https://img.shields.io/badge/TensorFlow-2.x-FF6F00?logo=tensorflow&logoColor=white)](https://tensorflow.org)
[![React](https://img.shields.io/badge/React-18-61DAFB?logo=react&logoColor=black)](https://react.dev)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white)](https://docker.com)

</div>

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Backend Setup](#1-backend-setup)
  - [Flutter App Setup](#2-flutter-app-setup)
  - [Web Frontend Setup](#3-web-frontend-setup)
- [AI Models](#-ai-models)
- [API Reference](#-api-reference)
- [Environment Variables](#-environment-variables)
- [Contributing](#-contributing)

---

## 🌱 Overview

LeafCompass bridges the gap between modern AI and farming. Farmers and agronomists can use the **Flutter mobile app** or the **React web interface** to get instant, data-driven insights — from snapping a photo of a diseased leaf to receiving a tailored fertilizer recommendation based on soil conditions.

The platform is powered by a **FastAPI backend** that serves four trained machine learning models and integrates **DeepSeek V3** (via Hugging Face) as the conversational AI assistant.

---

## ✨ Features

| Feature | Description |
|---|---|
| 🍃 **Disease Detection** | Upload or photograph a leaf; a TensorFlow CNN identifies the disease and provides a confidence score |
| 📈 **Yield Prediction** | Predict crop yield (tons/ha) based on rainfall, temperature, soil type, region, and more |
| 🌾 **Crop Recommendation** | Enter NPK values, pH, humidity, and state to get the best crop for your field |
| 🧪 **Fertilizer Recommendation** | Receive fertilizer suggestions tailored to your soil moisture, crop type, and nutrient levels |
| 🤖 **AgroBot Chat** | Conversational AI assistant (DeepSeek V3) for agronomy questions, feature guidance, and more |

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     Client Layer                        │
│  ┌──────────────────────┐   ┌─────────────────────────┐ │
│  │   Flutter Mobile App │   │  React Web Frontend     │ │
│  │  (Android / iOS)     │   │  (Tailwind CSS)         │ │
│  └──────────┬───────────┘   └────────────┬────────────┘ │
└─────────────┼────────────────────────────┼──────────────┘
              │            REST API         │
              ▼                             ▼
┌─────────────────────────────────────────────────────────┐
│                  FastAPI Backend                        │
│  ┌─────────────┐ ┌───────────────┐ ┌─────────────────┐ │
│  │  TensorFlow │ │  scikit-learn │ │  Hugging Face   │ │
│  │  (Disease)  │ │  (Yield/Crop/ │ │  DeepSeek V3.2  │ │
│  │             │ │  Fertilizer)  │ │  (AgroBot)      │ │
│  └─────────────┘ └───────────────┘ └─────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

---

## 🛠️ Tech Stack

### Mobile App (Flutter)
- **Flutter 3.x** with Material 3 design
- **go_router** — declarative navigation
- **google_fonts** — Inter typeface
- **flutter_animate** — micro-animations
- **image_picker** — camera & gallery access
- **http** — REST API communication

### Backend (Python / FastAPI)
- **FastAPI** + **Uvicorn** — high-performance async API
- **TensorFlow / Keras** — plant disease CNN model
- **scikit-learn / joblib** — yield, crop, and fertilizer models
- **Pandas / NumPy** — data processing
- **Hugging Face `InferenceClient`** — DeepSeek V3.2 chat
- **Pillow** — server-side image preprocessing
- **Docker** — containerised deployment

### Web Frontend (React)
- **React 18** + **Tailwind CSS**
- **PostCSS** — CSS processing

---

## 📁 Project Structure

```
Leaf-Compass/
├── backend/                    # FastAPI server
│   ├── main.py                 # All API endpoints & model loading
│   ├── requirements.txt        # Python dependencies
│   ├── Dockerfile              # Container configuration
│   └── models/                 # Trained model files (.h5, .pkl)
│       ├── plant_disease_prediction_model.h5
│       ├── class_indices.json
│       ├── yield_prediction_model.pkl
│       ├── crop_recommendation_model.pkl
│       └── fertilizer_recommendation_model.pkl
│
├── flutter_frontend/           # Flutter mobile application
│   ├── lib/
│   │   ├── main.dart           # App entry point, theme, routing
│   │   ├── screens/
│   │   │   ├── home_screen.dart
│   │   │   ├── disease_screen.dart
│   │   │   ├── yield_screen.dart
│   │   │   ├── crop_screen.dart
│   │   │   ├── fertilizer_screen.dart
│   │   │   └── chat_screen.dart
│   │   ├── services/
│   │   │   └── api_service.dart   # HTTP client for backend
│   │   ├── models/
│   │   │   └── chat_message.dart
│   │   └── widgets/               # Reusable UI components
│   └── android/
│       └── app/src/main/
│           ├── AndroidManifest.xml
│           └── res/xml/network_security_config.xml
│
├── frontend/                   # React web application
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── tailwind.config.js
│
└── model training/             # Jupyter notebooks & training scripts
    ├── Crop_Disease_Detection/
    ├── Crop_prediction_model/
    ├── Fertilizer_recommendation/
    └── Yield_prediction_Model/
```

---

## 🚀 Getting Started

### Prerequisites

| Tool | Version |
|---|---|
| Flutter SDK | ≥ 3.0 |
| Dart SDK | ≥ 3.0 |
| Python | ≥ 3.10 |
| Node.js | ≥ 18 |
| Docker (optional) | ≥ 24 |

---

### 1. Backend Setup

```bash
cd backend

# Create and activate a virtual environment
python -m venv .venv
source .venv/bin/activate       # Windows: .venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Create your .env file and add your API key
# (see Environment Variables section below)

# Place your trained model files in backend/models/

# Start the server
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

**Or with Docker:**

```bash
cd backend
docker build -t leafcompass-api .
docker run -p 8000:8000 --env-file .env leafcompass-api
```

The API will be available at `http://localhost:8000`.
Visit `http://localhost:8000/docs` for the interactive Swagger UI.

---

### 2. Flutter App Setup

```bash
cd flutter_frontend

# Install dependencies
flutter pub get

# Update the API base URL in lib/services/api_service.dart
# For Android emulator use: http://10.0.2.2:8000

# Run on a connected device or emulator
flutter run

# Build a release APK
flutter build apk --release
```

> **Network Note:** `android/app/src/main/res/xml/network_security_config.xml` is already configured to allow cleartext traffic to localhost during development.

---

### 3. Web Frontend Setup

```bash
cd frontend

npm install
npm run dev
```

The web app will be available at `http://localhost:3000`.

---

## 🧠 AI Models

| Model | Type | Task | Input |
|---|---|---|---|
| **Plant Disease CNN** | TensorFlow / Keras `.h5` | Classify 38 plant disease categories | 224×224 leaf image |
| **Yield Predictor** | scikit-learn `.pkl` | Predict crop yield in tons/ha | Weather, soil, crop, region params |
| **Crop Recommender** | scikit-learn `.pkl` | Suggest the optimal crop | NPK values, pH, humidity, state |
| **Fertilizer Recommender** | scikit-learn `.pkl` | Recommend fertilizer type | Soil nutrients, crop type, moisture |
| **AgroBot** | DeepSeek V3.2 (Hugging Face) | Conversational agronomy assistant | Natural language |

Training notebooks for all four local models are in the `model training/` directory.

---

## 📡 API Reference

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/` | Health check — returns server status |
| `POST` | `/predict-disease` | Upload a leaf image (`multipart/form-data`) → disease class + confidence |
| `POST` | `/predict-yield` | JSON body with weather/soil/crop fields → predicted yield (tons/ha) |
| `POST` | `/recommend-crop` | JSON body with NPK/pH/climate data → recommended crop |
| `POST` | `/recommend-fertilizer` | JSON body with soil/crop/nutrient data → recommended fertilizer |
| `POST` | `/chat` | `{ "message": "..." }` → AgroBot reply |

Full interactive docs at `/docs` (Swagger UI) and `/redoc` when the server is running.

---

## 🔐 Environment Variables

Create a `.env` file inside the `backend/` directory:

```env
# Hugging Face API token for DeepSeek V3.2 (AgroBot)
API=hf_your_hugging_face_token_here
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/your-feature-name`
3. **Commit** your changes: `git commit -m 'feat: add your feature'`
4. **Push** to the branch: `git push origin feature/your-feature-name`
5. **Open** a Pull Request

Please ensure your code follows existing conventions and includes relevant documentation updates.

---

<div align="center">

Made with 🌿 for smarter farming

</div>
