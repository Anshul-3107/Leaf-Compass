# Use Python 3.11
FROM python:3.11

# Set working directory
WORKDIR /app

# 1. Install heavy PyTorch CPU dependencies first (caches this layer)
RUN pip install --no-cache-dir torch==2.11.0 torchvision==0.26.0 --index-url https://download.pytorch.org/whl/cpu

# 2. Install the rest of the requirements (pip will skip torch/torchvision as they are satisfied)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# 3. Bake real model weights into the Docker image at build time from Hugging Face storage
RUN python -c "\
import urllib.request, os; \
models = [ \
    'crop_recommendation_model.pkl', \
    'fertilizer_recommendation_model.pkl', \
    'plant_disease_prediction_model.pt', \
    'yield_prediction_model.pkl' \
]; \
os.makedirs('models', exist_ok=True); \
for m in models: \
    url = f'https://huggingface.co/spaces/anshularohi/leaf-compass-api/resolve/main/models/{m}'; \
    dest = f'models/{m}'; \
    if not (os.path.exists(dest) and os.path.getsize(dest) > 10240): \
        print(f'Baking model {m} into image...'); \
        urllib.request.urlretrieve(url, dest); \
        print(f'Done {m}: {os.path.getsize(dest)} bytes')"

# Create a non-root user and grant permissions to /app
RUN useradd -m -u 1000 user && chown -R user:user /app
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

# Expose the port (Hugging Face Spaces expects 7860; Render injects $PORT at runtime)
EXPOSE 7860

# Use ${PORT:-7860}: falls back to 7860 on HF Spaces, uses Render's injected $PORT otherwise
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-7860}"]