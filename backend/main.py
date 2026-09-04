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

# TensorFlow is optional
try:
    import tensorflow as tf
    TF_AVAILABLE = True
except ModuleNotFoundError:
    tf = None
    TF_AVAILABLE = False
    print("⚠️  TensorFlow not available (requires Python ≤ 3.12). Disease detection disabled.")

# --- CONFIGURATION & SETUP ---
load_dotenv() # Loads environment variables from .env file

app = FastAPI()

# CORS Setup
# NOTE: Render service slugs are always lowercase — update the URL below
# to match your exact Render service name if it differs.
# The HuggingFace Spaces URL is https://jain-mayukh-lc-api.hf.space
origins = [
    "http://localhost:3000",
    "https://leafcompass.onrender.com",       # Render (lowercase slug)
    "https://jain-mayukh-lc-api.hf.space",   # Hugging Face Spaces
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- LOAD MODELS ---
print("--- Starting Server & Loading Models ---")

# Global variables for models
disease_model = None
yield_model = None
crop_model = None
fertilizer_model = None
class_names = {}

# 1. Load Plant Disease Model
try:
    if TF_AVAILABLE:
        disease_model = tf.keras.models.load_model("./models/plant_disease_prediction_model.h5")
        with open("./models/class_indices.json", "r") as f:
            class_indices = json.load(f)
        class_names = {int(k): v for k, v in class_indices.items()}
        print("✅ Disease Model Loaded.")
    else:
        print("⚠️  Skipping disease model — TensorFlow not installed.")
except FileNotFoundError:
    print(
        "❌ plant_disease_prediction_model.h5 not found in ./models/. "
        "This file is not committed to git due to its size. "
        "TODO: replace with your actual model hosting URL — "
        "download and place it in backend/models/ before starting the server."
    )
except Exception as e:
    print(f"❌ Error loading disease model: {e}")

# 2. Load Yield Prediction Model
try:
    yield_model = joblib.load("./models/yield_prediction_model.pkl")
    print("✅ Yield Model Loaded.")
except FileNotFoundError:
    print(
        "❌ yield_prediction_model.pkl not found in ./models/. "
        "This file is not committed to git due to its size. "
        "TODO: replace with your actual model hosting URL — "
        "download and place it in backend/models/ before starting the server."
    )
except Exception as e:
    print(f"❌ Error loading yield model: {e}")

# 3. Load Crop Recommendation Model
try:
    crop_model = joblib.load("./models/crop_recommendation_model.pkl")
    print("✅ Crop Model Loaded.")
except Exception as e:
    print(f"❌ Error loading crop model: {e}")

# 4. Load Fertilizer Recommendation Model
try:
    fertilizer_model = joblib.load("./models/fertilizer_recommendation_model.pkl")
    print("✅ Fertilizer Model Loaded.")
except Exception as e:
    print(f"❌ Error loading fertilizer model: {e}")

# 5. Configure DeepSeek AI via Hugging Face Inference API
client = InferenceClient(model="deepseek-ai/DeepSeek-V3.2", token=os.getenv("API"))


# --- DATA STRUCTURES (Pydantic Models) ---

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


# --- ENDPOINTS ---

@app.get("/")
def ping():
    return {"message": "LeafCompass Server is running 🚀"}

@app.post("/predict-disease")
async def predict_disease(file: UploadFile = File(...)):
    if not disease_model:
        return {"error": "Disease model is not loaded."}
    
    try:
        # Process Image
        image_data = await file.read()
        image = Image.open(BytesIO(image_data))
        image = image.resize((224, 224))
        image = np.array(image).astype('float32') / 255.0
        img_batch = np.expand_dims(image, 0)
        
        # Predict
        predictions = disease_model.predict(img_batch)
        predicted_index = np.argmax(predictions[0])
        confidence = float(np.max(predictions[0]))
        
        return {
            "class": class_names.get(predicted_index, "Unknown"),
            "confidence": confidence
        }
    except Exception as e:
        return {"error": str(e)}

@app.post("/predict-yield")
def predict_yield(data: YieldInput):
    if not yield_model:
        return {"error": "Yield model is not loaded."}

    input_data = pd.DataFrame([data.model_dump()])
    
    # Ensure categorical variables (Region, Soil, Crop) are handled 
    # if your model pipeline expects them encoded, ensure input_data is processed here.
    
    prediction = yield_model.predict(input_data)
    return {"predicted_yield": float(prediction[0])}

@app.post("/recommend-crop")
def recommend_crop(data: CropInput):
    if not crop_model:
        return {"error": "Crop model is not loaded."}
    
    # Note: Ensure 'data.state' is encoded if your model expects a number!
    features = pd.DataFrame([[
        data.N, data.P, data.K, 
        data.temperature, data.humidity, data.ph, 
        data.rainfall, data.state
    ]], columns=['N_SOIL', 'P_SOIL', 'K_SOIL', 'TEMPERATURE', 'HUMIDITY', 'ph', 'RAINFALL', 'STATE'])
    
    prediction = crop_model.predict(features)
    return {"recommended_crop": prediction[0]}

@app.post("/recommend-fertilizer")
def recommend_fertilizer(data: FertilizerInput):
    if not fertilizer_model:
        return {"error": "Fertilizer model is not loaded."}

    input_df = pd.DataFrame([[
        data.Temperature, data.Humidity, data.Moisture, 
        data.Soil_Type, data.Crop_Type, 
        data.Nitrogen, data.Potassium, data.Phosphorous
    ]], columns=[
        'Temperature', 'Humidity', 'Moisture', 'Soil_Type', 
        'Crop_Type', 'Nitrogen', 'Potassium', 'Phosphorous'
    ])
    
    prediction = fertilizer_model.predict(input_df)
    return {"recommended_fertilizer": prediction[0]}

@app.post("/chat")
def chat_endpoint(data: ChatInput):
    try:
        # Create the message structure required by the "conversational" task
        messages = [
            {"role": "system", "content": '''You are AgroBot, an intelligent agricultural assistant integrated into the 'LeafCompass' application.
            Your capabilities:
            1. Diagnose plant diseases based on symptoms described by the user.
            2. Explain crop yield predictions.
            3. Recommend fertilizers for specific soil types.
            4. Suggest crops based on NPK values and climate.
            Guidelines:
            - Keep answers concise (under 3-4 sentences).
            - Use emojis (🌾, 🚜, 🍃).
            - If asked about app features, guide them: Disease -> 'Disease' tab, Yield -> 'Yield' tab.
            '''},
            {"role": "user", "content": data.message}
        ]

        # Use chat_completion instead of text_generation
        response = client.chat_completion(
            messages, 
            max_tokens=200
        )

        # Extract the actual text from the response object
        bot_reply = response.choices[0].message.content
        
        return {"response": bot_reply}

    except Exception as e:
        print(f"Chat Error: {e}")
        return {"response": "I'm having trouble connecting to the satellite. 📡 Please try again later!"}
    
if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8000)