from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import numpy as np
from io import BytesIO
from PIL import Image
import tensorflow as tf
import joblib
import pandas as pd
import json
from pydantic import BaseModel

app = FastAPI()

# Allow React to access this API (CORS)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- LOAD MODELS ---
print("Loading Models...")

# 1. Load Plant Disease Model
try:
    disease_model = tf.keras.models.load_model("./models/plant_disease_prediction_model.h5")
    with open("./models/class_indices.json", "r") as f:
        class_indices = json.load(f)
    # Invert dictionary to get ID -> Name mapping if necessary, or use as is
    # Your JSON is saved as {"0": "Apple_Scab", ...} usually
    class_names = {int(k): v for k, v in class_indices.items()}
    print("Disease Model Loaded.")
except Exception as e:
    print(f"Error loading disease model: {e}")

# 2. Load Yield Prediction Model
try:
    yield_model = joblib.load("./models/yield_prediction_model.pkl")
    print("Yield Model Loaded.")
except Exception as e:
    print(f"Error loading yield model: {e}")

# ... previous model loading ...

# 3. Load Crop Recommendation Model
crop_model = None
try:
    crop_model = joblib.load("./models/crop_recommendation_model.pkl")
    print("✅ Crop Model Loaded.")
except Exception as e:
    print(f"⚠️ Crop model not found: {e}")

# 4. Load Fertilizer Recommendation Model
fertilizer_model = None
try:
    fertilizer_model = joblib.load("./models/fertilizer_recommendation_model.pkl")
    print("✅ Fertilizer Model Loaded.")
except Exception as e:
    print(f"⚠️ Fertilizer model not found: {e}")


# --- ENDPOINTS ---

@app.get("/")
def ping():
    return {"message": "Server is running"}

# 1. Disease Prediction Endpoint
def read_file_as_image(data) -> np.ndarray:
    image = Image.open(BytesIO(data))
    image = image.resize((224, 224)) # Resize to match training
    image = np.array(image)
    image = image.astype('float32') / 255.0 # Normalize
    return image

@app.post("/predict-disease")
async def predict_disease(file: UploadFile = File(...)):
    image = read_file_as_image(await file.read())
    img_batch = np.expand_dims(image, 0)
    
    predictions = disease_model.predict(img_batch)
    predicted_class_index = np.argmax(predictions[0])
    confidence = float(np.max(predictions[0]))
    
    return {
        "class": class_names.get(predicted_class_index, "Unknown"),
        "confidence": confidence
    }

# 2. Yield Prediction Endpoint
from pydantic import BaseModel

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

@app.post("/predict-yield")
def predict_yield(data: YieldInput):
    # Convert Pydantic object to Pandas DataFrame
    # Note: Column names must match EXACTLY what you trained on
    input_data = pd.DataFrame([data.dict()])
    
    # Predict
    prediction = yield_model.predict(input_data)
    
    return {
        "predicted_yield": float(prediction[0])
    }

# --- CROP RECOMMENDATION ENDPOINT ---
# --- CROP RECOMMENDATION ENDPOINT ---

class CropInput(BaseModel):
    N: float
    P: float
    K: float
    temperature: float
    humidity: float
    ph: float
    rainfall: float
    state: str  # <--- Added STATE

@app.post("/recommend-crop")
def recommend_crop(data: CropInput):
    if crop_model is None:
        return {"error": "Crop model not loaded. Please check server logs."}
    
    # Prepare inputs. Order MUST match the error message:
    # [N, P, K, Temp, Hum, pH, Rain, State]
    features = pd.DataFrame([[
        data.N, 
        data.P, 
        data.K, 
        data.temperature, 
        data.humidity, 
        data.ph, 
        data.rainfall,
        data.state
    ]], columns=['N_SOIL', 'P_SOIL', 'K_SOIL', 'TEMPERATURE', 'HUMIDITY', 'ph', 'RAINFALL', 'STATE'])
    
    # Make Prediction
    prediction = crop_model.predict(features)
    
    return {"recommended_crop": prediction[0]}

# --- FERTILIZER RECOMMENDATION ---
class FertilizerInput(BaseModel):
    Temperature: float
    Humidity: float
    Moisture: float
    Soil_Type: str  # Expecting string (e.g., 'Sandy')
    Crop_Type: str  # Expecting string (e.g., 'Maize')
    Nitrogen: float
    Potassium: float
    Phosphorous: float

@app.post("/recommend-fertilizer")
def recommend_fertilizer(data: FertilizerInput):
    if fertilizer_model is None:
        return {"error": "Fertilizer model not loaded."}

    # FIX: Create a DataFrame with specific column names to satisfy the model pipeline
    # Note: These names must match your training dataset EXACTLY.
    input_df = pd.DataFrame([[
        data.Temperature, 
        data.Humidity, 
        data.Moisture, 
        data.Soil_Type, 
        data.Crop_Type, 
        data.Nitrogen, 
        data.Potassium, 
        data.Phosphorous
    ]], columns=[
        'Temperature', 'Humidity', 'Moisture', 'Soil_Type', 'Crop_Type', 'Nitrogen', 'Potassium', 'Phosphorous'
    ])
    
    # Make Prediction
    prediction = fertilizer_model.predict(input_df)
    
    return {"recommended_fertilizer": prediction[0]}

# ... existing imports ...
import google.generativeai as genai
import os

# --- CONFIGURATION ---

# PASTE YOUR API KEY HERE
GEMINI_API_KEY = "AIzaSyBAkl78hjU33Xx3gQHfqsBPQK-mx3b6JPs" 

# Configure the AI
genai.configure(api_key=GEMINI_API_KEY)

# Set up the model with specific instructions to act as an Agri-Expert
model = genai.GenerativeModel(
    model_name="gemini-2.5-flash-lite",
    system_instruction="""
    You are AgroBot, an intelligent agricultural assistant integrated into the 'AgroAI' web application.
    
    Your capabilities:
    1. Diagnose plant diseases based on symptoms described by the user.
    2. Explain crop yield predictions (based on rainfall and temperature).
    3. Recommend fertilizers for specific soil types.
    4. Suggest crops based on NPK values and climate.

    Guidelines:
    - Keep answers concise (under 3-4 sentences) unless asked for details.
    - Use emojis to be friendly (e.g., 🌾, 🚜, 🍃).
    - If the user asks about the app features, guide them:
      * Disease Detection -> "Check the 'Disease' tab."
      * Yield Prediction -> "Go to the 'Yield' tab."
    - If asked about non-agricultural topics (like coding, movies, politics), politely refuse and steer back to farming.
    """
)

# Initialize chat history (simple session for the API instance)
chat_session = model.start_chat(history=[])

# --- CHATBOT ENDPOINT ---

class ChatInput(BaseModel):
    message: str

@app.post("/chat")
def chat_endpoint(data: ChatInput):
    try:
        # Send message to Gemini
        response = chat_session.send_message(data.message)
        return {"response": response.text}
    except Exception as e:
        print(f"Gemini Error: {e}")
        return {"response": "I'm currently having trouble connecting to the satellite. 📡 Please try again later!"}

if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8000)