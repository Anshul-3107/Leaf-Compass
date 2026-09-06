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

# Create a non-root user (Security requirement for HF Spaces)
RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

# Expose the port (Hugging Face Spaces expects 7860; Render injects $PORT at runtime)
EXPOSE 7860

# Use ${PORT:-7860}: falls back to 7860 on HF Spaces, uses Render's injected $PORT otherwise
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-7860}"]