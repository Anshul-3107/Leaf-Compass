import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import time

# Models
from sklearn.linear_model import LinearRegression
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor

# Metrics & Tools
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error, r2_score
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder, StandardScaler

# 1. Load Data
df = pd.read_csv('cleaned_agricultural_data.csv')
X = df.drop('Yield_tons_per_hectare', axis=1)
y = df['Yield_tons_per_hectare']

# 2. Split Data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 3. Define the Preprocessor (Same for all models)
categorical_features = ['Region', 'Soil_Type', 'Crop', 'Weather_Condition']
numerical_features = ['Rainfall_mm', 'Temperature_Celsius', 'Days_to_Harvest']

preprocessor = ColumnTransformer(
    transformers=[
        ('num', StandardScaler(), numerical_features),
        ('cat', OneHotEncoder(handle_unknown='ignore', sparse_output=False), categorical_features)
    ],
    remainder='passthrough'
)

# 4. Define the Contenders (The Models)
models = {
    "Linear Regression": LinearRegression(),
    
    "Decision Tree": DecisionTreeRegressor(max_depth=15, random_state=42),
    
    "Random Forest": RandomForestRegressor(n_estimators=50, max_depth=15, n_jobs=-1, random_state=42),
    
    # Gradient Boosting is powerful but can be slow. 
    # We limit n_estimators to 50 to keep it fast on your laptop.
    "Gradient Boosting": GradientBoostingRegressor(n_estimators=50, max_depth=5, random_state=42)
}

# 5. The Training Loop
results = []
print("--- Starting Model Championship ---")

for name, model in models.items():
    print(f"Training {name}...")
    start_time = time.time()
    
    # Create Pipeline
    pipeline = Pipeline(steps=[('preprocessor', preprocessor), ('model', model)])
    
    # Train
    pipeline.fit(X_train, y_train)
    
    # Predict
    y_pred = pipeline.predict(X_test)
    
    # Evaluate
    mae = mean_absolute_error(y_test, y_pred)
    r2 = r2_score(y_test, y_pred)
    elapsed_time = time.time() - start_time
    
    results.append({
        "Model": name,
        "MAE (Lower is better)": mae,
        "R2 Score (Higher is better)": r2,
        "Training Time (s)": elapsed_time
    })


# 6. Display Results (CORRECTED)
# We must use the EXACT string key defined in the results dictionary
results_df = pd.DataFrame(results).sort_values(by='R2 Score (Higher is better)', ascending=False)

print("\n--- Final Standings ---")
print(results_df)

# 7. Visualization (CORRECTED)
plt.figure(figsize=(12, 5))

# Plot R2 Score
plt.subplot(1, 2, 1)
# Use the exact key here too
sns.barplot(x='R2 Score (Higher is better)', y='Model', data=results_df, palette='viridis')
plt.title('Accuracy Comparison (R2 Score)')
plt.xlim(0, 1) 

# Plot MAE
plt.subplot(1, 2, 2)
# Use the exact key here too
sns.barplot(x='MAE (Lower is better)', y='Model', data=results_df, palette='magma')
plt.title('Error Comparison (MAE)')

plt.tight_layout()
plt.show()