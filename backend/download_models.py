import os
import urllib.request

MODELS = [
    "crop_recommendation_model.pkl",
    "fertilizer_recommendation_model.pkl",
    "plant_disease_prediction_model.pt",
    "yield_prediction_model.pkl",
]

BASE_URL = "https://huggingface.co/spaces/anshularohi/leaf-compass-api/resolve/main/models"
MODELS_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "models")

os.makedirs(MODELS_DIR, exist_ok=True)

print("--- Starting Build-Time Model Download ---")

for model_name in MODELS:
    dest_path = os.path.join(MODELS_DIR, model_name)
    # Check if file exists and is a real model binary (> 10 KB), not an unpulled Git LFS pointer (~130 bytes)
    if os.path.exists(dest_path) and os.path.getsize(dest_path) > 10240:
        print(f"[OK] {model_name} already present ({os.path.getsize(dest_path)} bytes).")
        continue

    url = f"{BASE_URL}/{model_name}"
    print(f"[DOWNLOADING] {model_name} from {url} ...")
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"})
    
    with urllib.request.urlopen(req, timeout=120) as response, open(dest_path, "wb") as out_file:
        while True:
            chunk = response.read(1024 * 1024)  # 1MB chunks
            if not chunk:
                break
            out_file.write(chunk)
            
    print(f"[OK] Downloaded {model_name} ({os.path.getsize(dest_path)} bytes).")

print("--- All Models Verified and Ready ---")
