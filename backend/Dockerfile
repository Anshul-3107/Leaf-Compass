# Use Python 3.9
FROM python:3.11

# Set working directory
WORKDIR /app

# Copy requirements and install
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