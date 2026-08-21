import pandas as pd
import joblib
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.ensemble import RandomForestRegressor
import os

# 1. Load Data
df = pd.read_csv('cleaned_agricultural_data.csv')
X = df.drop('Yield_tons_per_hectare', axis=1)
y = df['Yield_tons_per_hectare']

# 2. Setup Preprocessor
categorical_features = ['Region', 'Soil_Type', 'Crop', 'Weather_Condition']
numerical_features = ['Rainfall_mm', 'Temperature_Celsius', 'Days_to_Harvest']

preprocessor = ColumnTransformer(
    transformers=[
        ('num', StandardScaler(), numerical_features),
        ('cat', OneHotEncoder(handle_unknown='ignore', sparse_output=False), categorical_features)
    ],
    remainder='passthrough'
)

# 3. Create and Train Pipeline (Random Forest was usually best)
model = RandomForestRegressor(n_estimators=50, max_depth=15, n_jobs=-1, random_state=42)
pipeline = Pipeline(steps=[('preprocessor', preprocessor), ('model', model)])

print("Training Yield Model...")
pipeline.fit(X, y)

# 4. Save the model to backend
target_dir = r"D:\leafcompass\Leaf-Compass\backend\models"
os.makedirs(target_dir, exist_ok=True)
target_path = os.path.join(target_dir, "yield_prediction_model.pkl")

joblib.dump(pipeline, target_path)
print(f"✅ Model saved successfully to {target_path}")
