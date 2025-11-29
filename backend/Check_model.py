import joblib
import os

# Adjust path if necessary
model_path = "backend/models/fertilizer_recommendation_model.pkl"

if os.path.exists(model_path):
    print(f"Loading {model_path}...")
    model = joblib.load(model_path)
    
    # Check expected features
    if hasattr(model, "feature_names_in_"):
        print(f"❌ ERROR: Model expects these {len(model.feature_names_in_)} features:")
        print(model.feature_names_in_)
    elif hasattr(model, "n_features_in_"):
        print(f"❌ ERROR: Model expects {model.n_features_in_} features, but API provides 7.")
    else:
        print("Could not determine features, but the count mismatch confirms the wrong model.")
else:
    print("Model file not found.")