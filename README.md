
# 🌿 LeafCompass - Smart Farming AI

![Logo](./frontend/src/assets/logo2.png)

[LeafCompass](https://leafcompass.vercel.app/) is an intelligent agricultural assistant designed to empower farmers with data-driven insights. It leverages Machine Learning and Generative AI to diagnose plant diseases, recommend crops, predict yields, and provide real-time farming advice via a chatbot.

🚀 Live Demo
- Frontend (Vercel): https://leafcompass.vercel.app/ 

- Backend API (Hugging Face): https://jain-mayukh-lc-api.hf.space/docs 
## ✨ Key Features
#### 🍂 Plant Disease Detection
- Input: Upload an image of a crop leaf.

- Model: Convolutional Neural Network (CNN) built with TensorFlow/Keras.

- Output: Identifies the disease name and confidence level.

#### 🌾 Crop Yield Prediction
- Input: Rainfall, Temperature, Soil Type, Region, Weather, etc.

- Model: Random Forest Regressor (Scikit-Learn).

- Output: Predicted yield in kg/ha.

#### 🌱 Crop Recommendation
- Input: Soil N-P-K values, pH, Humidity, Rainfall, State.

- Model: Random Forest Classifier.

- Output: The most suitable crop for the given conditions.

#### 🧪 Fertilizer Recommendation
- Input: Soil stats, Crop type, Moisture.

- Model: Classification Model.

- Output: Recommended fertilizer type.

#### 🤖 AgroBot (AI Chat)
- Engine: deepseek-ai/DeepSeek-V3.2 (via Hugging Face Inference API).

- Function: Answers general farming questions in real-time.

## 🛠️ Tech Stack
#### Frontend
- Framework: React.js
- Styling: Tailwind CSS
- Icons: Lucide React
- Routing: React Router DOM
- HTTP Client: Axios

#### Backend
- Framework: FastAPI (Python)
- ML Libraries: TensorFlow, Scikit-learn, Pandas, NumPy
- AI Integration: Hugging Face Inference Client (huggingface_hub)
- Deployment: Docker (Hugging Face Spaces)

## ⚙️ Local Installation & Setup
Follow these steps to run the project locally on your machine.

#### Prerequisites
- Node.js & npm installed.
- Python 3.9+ installed.
- Git installed.
1 . Clone the Repository
```bash
git clone https://github.com/your-username/leaf-compass.git
cd leaf-compass
```

2 . Backend Setup

The backend handles the ML models. Note that you will have to download the large model files from Google Drive.

```Bash

# Navigate to backend folder
cd backend

# Create a virtual environment (Optional but recommended)
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install Python dependencies
pip install -r requirements.txt

# Run the Server
python main.py
```
The server will start at `http://localhost:8000`.

3 . Frontend Setup

Open a new terminal for the frontend.

```Bash

# Navigate to frontend folder
cd frontend

# Install dependencies
npm install

# Start the React App
npm start
```
The app will open at `http://localhost:3000`.

## 📂 Project Structure
```bash
leaf-compass/
├── backend/
│   ├── models/                # ML Models (.h5, .pkl) - Auto-downloaded
│   ├── main.py                # FastAPI entry point & endpoints
│   ├── requirements.txt       # Python dependencies
│   ├── Dockerfile             # Docker config for Hugging Face
│   └── README.md              # Backend specific info
├── frontend/
│   ├── src/
│   │   ├── components/        # Reusable UI (Header, Footer, Forms)
│   │   ├── pages/             # Page Views (Home, Disease, Yield, etc.)
│   │   ├── services/          # API.js (Axios configuration)
│   │   └── App.js             # Main Router
│   ├── tailwind.config.js     # Tailwind settings
│   └── package.json           # Node dependencies
└── README.md                  # Main documentation
```

## 🧠 Model Details
| Feature | Algorithm | Input Data | Accuracy (Approx) |
| :-------- | :------- | :-------- | :---- | 
| Disease Detection	| CNN (MobileNetV2/Custom) | Leaf Images (224x224) | ~92% |
|Yield Prediction | Random Forest Regressor | Weather & Soil Data | ~88% (R2 Score)|
|Crop Recommender | Random Forest Classifier | NPK, pH, Rainfall | ~99% |
|Fertilizer Recommender | XGBoost/Random Forest	| Soil & Crop Data | ~95% |

## 🔑 Environment Variables
This project requires a Hugging Face Token for the AI Chatbot.

1 . Locally: You can add HUGGING_FACE_TOKEN in a .env file or hardcode it in main.py (not recommended for public repos).

2 . Hugging Face Spaces: Set it in the "Settings" -> "Variables and secrets" tab.

## 🚀 Deployment Guide
#### Backend (Hugging Face Spaces)
The backend is Dockerized to handle large dependencies.

- Create a Space on Hugging Face (SDK: Docker).

- Enable Git LFS if pushing models directly (or use the Google Drive downloader script provided in main.py).

- Push the backend folder contents to the Space.

#### Frontend (Vercel)
- Push the frontend folder to GitHub.

- Import the repo into Vercel.

- Set the Root Directory to frontend.

- Deploy!

## 🤝 Contributing
Contributions are welcome! Please follow these steps:

1 . Fork the repository.

2 . Create a new branch (git checkout -b feature-branch).

3 . Commit your changes.

4 . Push to the branch.

5 . Open a Pull Request.

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

Made with 💚 for the Farming Community.

