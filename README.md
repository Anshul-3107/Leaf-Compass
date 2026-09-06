<div align="center">

<img src="./flutter_frontend/assets/logo.png" alt="LeafCompass Logo" width="120" onerror="this.src='https://via.placeholder.com/120?text=LeafCompass'"/>

# 🌿 LeafCompass

### Smart Farming, Powered by AI

**LeafCompass** is an intelligent agricultural assistant that empowers farmers with data-driven insights — diagnose plant diseases, predict crop yields, get tailored recommendations, and chat with an AI agronomist. All in one unified mobile platform.

[![Backend API](https://img.shields.io/badge/Backend%20API-HuggingFace-FFD21E?style=for-the-badge&logo=huggingface&logoColor=black)](https://jain-mayukh-lc-api.hf.space/docs)
[![Flutter](https://img.shields.io/badge/Flutter-Mobile-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](./LICENSE)

</div>

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

- A seamless **Flutter mobile/desktop app**
- A robust **FastAPI backend** (capable of being hosted on Hugging Face Spaces or locally)

---

## ✨ Features

### 🍂 Plant Disease Detection
- **Input:** Upload a crop leaf image
- **Model:** Custom CNN built with PyTorch
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

### Mobile / Client Frontend (Flutter)
| Tool | Purpose |
|---|---|
| Flutter / Dart | Cross-platform UI framework |
| Dio / HTTP | REST API networking client |
| Material 3 | Modern UI components & styling |
| go_router | Declarative navigation (if applicable) |

### Backend (Python / FastAPI)
| Tool | Purpose |
|---|---|
| FastAPI + Uvicorn | High-performance async API server |
| PyTorch            | Plant disease CNN inference |
| Scikit-learn / Joblib | Yield, Crop & Fertilizer ML models |
| Pandas / NumPy | Data processing & structuring |
| Hugging Face `InferenceClient` | DeepSeek V3.2 LLM chat |
| Pillow | Server-side image preprocessing |

---

