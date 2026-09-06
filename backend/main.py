import os
import json
import uvicorn
import joblib
import numpy as np
import pandas as pd
from io import BytesIO
from PIL import Image
from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from dotenv import load_dotenv
from huggingface_hub import InferenceClient

# PyTorch for plant disease detection
import torch
import torchvision.transforms as T
from models.plant_disease_cnn import PlantDiseaseCNN


# ============================================================
# CONFIGURATION & SETUP
# ============================================================

load_dotenv()

app = FastAPI()


# ============================================================
# CORS SETUP
# ============================================================

origins = [
    "http://localhost:3000",

    # Render backend
    "https://leaf-compass-api.onrender.com",

    # Hugging Face Spaces
    "https://jain-mayukh-lc-api.hf.space",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ============================================================
# LOAD MODELS
# ============================================================

print("--- Starting Server & Loading Models ---")

disease_model = None
yield_model = None
crop_model = None
fertilizer_model = None
class_names = {}


# ------------------------------------------------------------
# 1. Plant Disease Model - PyTorch
# ------------------------------------------------------------

try:
    _disease_model = PlantDiseaseCNN(num_classes=38)

    _disease_model.load_state_dict(
        torch.load(
            "./models/plant_disease_prediction_model.pt",
            map_location="cpu",
            weights_only=False
        )
    )

    _disease_model.eval()

    disease_model = _disease_model

    with open("./models/class_indices.json", "r") as f:
        class_indices = json.load(f)

    class_names = {
        int(k): v for k, v in class_indices.items()
    }

    print("✅ Disease Model Loaded.")

except FileNotFoundError:
    print(
        "❌ plant_disease_prediction_model.pt not found in ./models/. "
        "Make sure the model is present in Git LFS."
    )

except Exception as e:
    print(f"❌ Error loading disease model: {e}")


# ------------------------------------------------------------
# 2. Yield Prediction Model
# ------------------------------------------------------------

try:
    yield_model = joblib.load(
        "./models/yield_prediction_model.pkl"
    )

    print("✅ Yield Model Loaded.")

except FileNotFoundError:
    print(
        "❌ yield_prediction_model.pkl not found in ./models/. "
        "Make sure the model is present in Git LFS."
    )

except Exception as e:
    print(f"❌ Error loading yield model: {e}")


# ------------------------------------------------------------
# 3. Crop Recommendation Model
# ------------------------------------------------------------

try:
    crop_model = joblib.load(
        "./models/crop_recommendation_model.pkl"
    )

    print("✅ Crop Model Loaded.")

except FileNotFoundError:
    print(
        "❌ crop_recommendation_model.pkl not found in ./models/."
    )

except Exception as e:
    print(f"❌ Error loading crop model: {e}")


# ------------------------------------------------------------
# 4. Fertilizer Recommendation Model
# ------------------------------------------------------------

try:
    fertilizer_model = joblib.load(
        "./models/fertilizer_recommendation_model.pkl"
    )

    print("✅ Fertilizer Model Loaded.")

except FileNotFoundError:
    print(
        "❌ fertilizer_recommendation_model.pkl not found in ./models/."
    )

except Exception as e:
    print(f"❌ Error loading fertilizer model: {e}")


# ------------------------------------------------------------
# 5. DeepSeek AI via Hugging Face
# ------------------------------------------------------------

client = InferenceClient(
    model="deepseek-ai/DeepSeek-V3.2",
    token=os.getenv("API")
)


# ============================================================
# DATA STRUCTURES
# ============================================================

class YieldInput(BaseModel):
    Rainfall_mm: float
    Temperature_Celsius: float
    Days_to_Harvest: int
    Region: str
    Soil_Type: str
    Crop: str
    Weather_Condition: str
    Fertilizer_Used: bool
    Irrigation_Used: bool


class CropInput(BaseModel):
    N: float
    P: float
    K: float
    temperature: float
    humidity: float
    ph: float
    rainfall: float
    state: str


class FertilizerInput(BaseModel):
    Temperature: float
    Humidity: float
    Moisture: float
    Soil_Type: str
    Crop_Type: str
    Nitrogen: float
    Potassium: float
    Phosphorous: float


class ChatInput(BaseModel):
    message: str


# ============================================================
# HEALTH CHECK
# ============================================================

@app.get("/")
def ping():
    return {
        "message": "LeafCompass Server is running 🚀"
    }


# ============================================================
# PLANT DISEASE IMAGE PREPROCESSING
# ============================================================

_disease_transform = T.Compose([
    T.Resize((224, 224)),
    T.ToTensor(),
    T.Normalize(
        mean=[0.485, 0.456, 0.406],
        std=[0.229, 0.224, 0.225]
    ),
])


# ============================================================
# PLANT DISEASE PREDICTION
# ============================================================

@app.post("/predict-disease")
async def predict_disease(
    file: UploadFile = File(...)
):

    if disease_model is None:
        return {
            "error": "Disease model is not loaded."
        }

    try:

        # Read uploaded image
        image_data = await file.read()

        image = Image.open(
            BytesIO(image_data)
        ).convert("RGB")

        # Preprocess
        tensor = _disease_transform(
            image
        ).unsqueeze(0)

        # Prediction
        with torch.no_grad():

            logits = disease_model(tensor)

            probs = torch.softmax(
                logits,
                dim=1
            )

            predicted_index = int(
                probs.argmax(dim=1)
            )

            confidence = float(
                probs.max()
            )

        return {
            "class": class_names.get(
                predicted_index,
                "Unknown"
            ),
            "confidence": confidence
        }

    except Exception as e:

        print(
            f"❌ Disease prediction error: {e}"
        )

        return {
            "error": str(e)
        }


# ============================================================
# YIELD PREDICTION
# ============================================================

@app.post("/predict-yield")
def predict_yield(data: YieldInput):

    if yield_model is None:
        return {
            "error": "Yield model is not loaded."
        }

    try:

        input_data = pd.DataFrame([
            data.model_dump()
        ])

        prediction = yield_model.predict(
            input_data
        )

        return {
            "predicted_yield": float(
                prediction[0]
            )
        }

    except Exception as e:

        print(
            f"❌ Yield prediction error: {e}"
        )

        return {
            "error": str(e)
        }


# ============================================================
# CROP RECOMMENDATION
# ============================================================

@app.post("/recommend-crop")
def recommend_crop(data: CropInput):

    if crop_model is None:
        return {
            "error": "Crop model is not loaded."
        }

    try:

        features = pd.DataFrame(
            [[
                data.N,
                data.P,
                data.K,
                data.temperature,
                data.humidity,
                data.ph,
                data.rainfall,
                data.state
            ]],
            columns=[
                "N_SOIL",
                "P_SOIL",
                "K_SOIL",
                "TEMPERATURE",
                "HUMIDITY",
                "ph",
                "RAINFALL",
                "STATE"
            ]
        )

        prediction = crop_model.predict(
            features
        )

        return {
            "recommended_crop": prediction[0]
        }

    except Exception as e:

        print(
            f"❌ Crop recommendation error: {e}"
        )

        return {
            "error": str(e)
        }


# ============================================================
# FERTILIZER RECOMMENDATION
# ============================================================

@app.post("/recommend-fertilizer")
def recommend_fertilizer(
    data: FertilizerInput
):

    if fertilizer_model is None:
        return {
            "error": "Fertilizer model is not loaded."
        }

    try:

        input_df = pd.DataFrame(
            [[
                data.Temperature,
                data.Humidity,
                data.Moisture,
                data.Soil_Type,
                data.Crop_Type,
                data.Nitrogen,
                data.Potassium,
                data.Phosphorous
            ]],
            columns=[
                "Temperature",
                "Humidity",
                "Moisture",
                "Soil_Type",
                "Crop_Type",
                "Nitrogen",
                "Potassium",
                "Phosphorous"
            ]
        )

        prediction = fertilizer_model.predict(
            input_df
        )

        return {
            "recommended_fertilizer": prediction[0]
        }

    except Exception as e:

        print(
            f"❌ Fertilizer recommendation error: {e}"
        )

        return {
            "error": str(e)
        }


# ============================================================
# AGROBOT CHAT
# ============================================================

@app.post("/chat")
def chat_endpoint(data: ChatInput):

    try:

        messages = [
            {
                "role": "system",
                "content": """
You are AgroBot, an intelligent agricultural assistant
integrated into the LeafCompass application.

Your capabilities:

1. Diagnose plant diseases based on symptoms described
   by the user.
2. Explain crop yield predictions.
3. Recommend fertilizers for specific soil types.
4. Suggest crops based on NPK values and climate.

Guidelines:

- Keep answers concise, under 3-4 sentences.
- Use emojis such as 🌾 🚜 🍃.
- If asked about app features, guide users:
  Disease -> Disease tab
  Yield -> Yield tab
"""
            },
            {
                "role": "user",
                "content": data.message
            }
        ]

        response = client.chat_completion(
            messages,
            max_tokens=200
        )

        bot_reply = (
            response
            .choices[0]
            .message
            .content
        )

        return {
            "response": bot_reply
        }

    except Exception as e:

        print(
            f"❌ Chat Error: {e}"
        )

        return {
            "response":
            "I'm having trouble connecting to the satellite. "
            "📡 Please try again later!"
        }


# ============================================================
# LOCAL / RENDER STARTUP
# ============================================================

if __name__ == "__main__":

    port = int(
        os.getenv("PORT", "8000")
    )

    uvicorn.run(
        app,
        host="0.0.0.0",
        port=port
    )