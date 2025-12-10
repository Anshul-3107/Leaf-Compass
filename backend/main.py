import os
import json
import uvicorn
import joblib
import numpy as np
import pandas as pd
import tensorflow as tf
from io import BytesIO
from PIL import Image
from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from dotenv import load_dotenv
from huggingface_hub import InferenceClient

# --- CONFIGURATION & SETUP ---
load_dotenv() # Loads environment variables from .env file

app = FastAPI()

# CORS Setup
origins = [
    "http://localhost:3000",
    "https://LeafCompass.onrender.com"
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
    disease_model = tf.keras.models.load_model("./models/plant_disease_prediction_model.h5")
    with open("./models/class_indices.json", "r") as f:
        class_indices = json.load(f)
    # Map indices to names
    class_names = {int(k): v for k, v in class_indices.items()}
    print("✅ Disease Model Loaded.")
except Exception as e:
    print(f"❌ Error loading disease model: {e}")

# 2. Load Yield Prediction Model
try:
    yield_model = joblib.load("./models/yield_prediction_model.pkl")
    print("✅ Yield Model Loaded.")
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

# 5. Configure Gemini AI

client = InferenceClient(model="deepseek-ai/DeepSeek-V3.2", token=os.getenv("API"))
# GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

# if GEMINI_API_KEY:
#     genai.configure(api_key=GEMINI_API_KEY)
#     try:
#         # Using standard flash model
#         model = genai.GenerativeModel(
#             model_name="gemini-1.5-flash", 
#             system_instruction="""
#             You are AgroBot, an intelligent agricultural assistant integrated into the 'AgroAI' web application.
#             Your capabilities:
#             1. Diagnose plant diseases based on symptoms described by the user.
#             2. Explain crop yield predictions.
#             3. Recommend fertilizers for specific soil types.
#             4. Suggest crops based on NPK values and climate.
#             Guidelines:
#             - Keep answers concise (under 3-4 sentences).
#             - Use emojis (🌾, 🚜, 🍃).
#             - If asked about app features, guide them: Disease -> 'Disease' tab, Yield -> 'Yield' tab.
#             """
#         )
#         chat_session = model.start_chat(history=[])
#         print("✅ Gemini AI Connected.")
#     except Exception as e:
#         print(f"❌ Error configuring Gemini: {e}")
#         chat_session = None
# else:
#     print("⚠️  Warning: GEMINI_API_KEY not found in .env file.")
#     chat_session = None


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
    return {"message": "AgroAI Server is running 🚀"}

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

    input_data = pd.DataFrame([data.dict()])
    
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
            {"role": "system", "content": '''You are AgroBot, an intelligent agricultural assistant integrated into the 'AgroAI' web application.
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