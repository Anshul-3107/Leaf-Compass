# =============================================================================
# Plant Disease Detection - CNN Image Classifier (PyTorch)
# PyTorch implementation
#
# WARNING: Training this CNN from scratch is SLOW on CPU.
# A GPU is strongly recommended (e.g. local NVIDIA GPU with CUDA, or
# Google Colab with a T4/A100 runtime).
# For local training on your RTX 3050, install the CUDA-enabled wheel:
#   pip install torch torchvision --index-url https://download.pytorch.org/whl/cu128
# =============================================================================

import os
import json
import subprocess
import sys
from zipfile import ZipFile
from pathlib import Path

import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader, random_split
from torchvision import datasets, transforms

# ---------------------------------------------------------------------------
# Allow importing the shared model class from backend/models/
# (This script lives at: model training/Crop_Disease_Detection/)
# ---------------------------------------------------------------------------
script_dir = Path(__file__).resolve().parent
backend_models_dir = (script_dir / ".." / ".." / "backend" / "models").resolve()
sys.path.insert(0, str(backend_models_dir.parent))   # adds backend/ to sys.path

# pyrefly: ignore [missing-import]
from models.plant_disease_cnn import PlantDiseaseCNN  # noqa: E402

# =============================================================================
# Configuration
# =============================================================================

DATASET_ZIP = "plantvillage-dataset.zip"
DATASET_DIR = "plantvillage dataset"
BASE_DIR    = "plantvillage dataset/color"

IMG_SIZE   = 224
BATCH_SIZE = 32
EPOCHS     = 5
LR         = 1e-3
VAL_SPLIT  = 0.2
NUM_CLASSES = 38

DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(f"Using device: {DEVICE}")
if DEVICE.type == "cuda":
    print(f"  GPU: {torch.cuda.get_device_name(0)}")

# =============================================================================
# 1. Download Dataset via Kaggle CLI
#    Requires ~/.kaggle/kaggle.json to be configured manually beforehand.
#    See: https://www.kaggle.com/docs/api#authentication
# =============================================================================

if not os.path.exists(DATASET_DIR):
    print("Downloading PlantVillage dataset from Kaggle...")
    subprocess.run(
        ["kaggle", "datasets", "download", "-d", "abdallahalidev/plantvillage-dataset"],
        check=True
    )
    print("Extracting dataset...")
    with ZipFile(DATASET_ZIP, "r") as zip_ref:
        zip_ref.extractall()
    print("Dataset ready.")
else:
    print(f"Dataset directory '{DATASET_DIR}' already exists -- skipping download.")

# =============================================================================
# 2. Data Loading & Preprocessing
# =============================================================================

# ImageNet mean/std normalisation is standard torchvision practice;
# functionally equivalent to the original notebook's raw /255 rescaling.
transform = transforms.Compose([
    transforms.Resize((IMG_SIZE, IMG_SIZE)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                         std=[0.229, 0.224, 0.225]),
])

full_dataset = datasets.ImageFolder(root=BASE_DIR, transform=transform)
print(f"Total samples: {len(full_dataset)}  |  Classes: {len(full_dataset.classes)}")

# 80 / 20 train-val split (deterministic via manual seed)
val_size   = int(len(full_dataset) * VAL_SPLIT)
train_size = len(full_dataset) - val_size
generator  = torch.Generator().manual_seed(0)
train_dataset, val_dataset = random_split(full_dataset, [train_size, val_size],
                                          generator=generator)
print(f"Train: {train_size}  |  Val: {val_size}")

# num_workers=0 is safest on Windows (avoids multiprocessing spawn issues)
train_loader = DataLoader(train_dataset, batch_size=BATCH_SIZE,
                          shuffle=True, num_workers=0)
val_loader   = DataLoader(val_dataset, batch_size=BATCH_SIZE,
                          shuffle=False, num_workers=0)

# =============================================================================
# 3. Model, Loss, Optimiser
# =============================================================================

model     = PlantDiseaseCNN(num_classes=NUM_CLASSES).to(DEVICE)
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=LR)

print("\nModel summary:")
print(model)

# =============================================================================
# 4. Training Loop
# =============================================================================

print(f"\nTraining for {EPOCHS} epochs on {DEVICE}...\n")

for epoch in range(1, EPOCHS + 1):
    # --- Train ---
    model.train()
    train_loss = 0.0
    for images, labels in train_loader:
        images, labels = images.to(DEVICE), labels.to(DEVICE)
        optimizer.zero_grad()
        logits = model(images)
        loss   = criterion(logits, labels)
        loss.backward()
        optimizer.step()
        train_loss += loss.item() * images.size(0)
    train_loss /= train_size

    # --- Validate ---
    model.eval()
    val_loss    = 0.0
    val_correct = 0
    with torch.no_grad():
        for images, labels in val_loader:
            images, labels = images.to(DEVICE), labels.to(DEVICE)
            logits  = model(images)
            loss    = criterion(logits, labels)
            val_loss += loss.item() * images.size(0)
            preds   = logits.argmax(dim=1)
            val_correct += (preds == labels).sum().item()
    val_loss     /= val_size
    val_accuracy  = val_correct / val_size * 100

    print(f"Epoch {epoch}/{EPOCHS}  "
          f"train_loss={train_loss:.4f}  "
          f"val_loss={val_loss:.4f}  "
          f"val_acc={val_accuracy:.2f}%")

# =============================================================================
# 5. Save Model State Dict and Class Index Mapping
# =============================================================================

output_dir = backend_models_dir
output_dir.mkdir(parents=True, exist_ok=True)

# --- Save state dict (portable, architecture-agnostic) ---
model_path = output_dir / "plant_disease_prediction_model.pt"
torch.save(model.state_dict(), model_path)
print(f"\nModel saved to {model_path}")

# --- Save class indices mapping ---
# ImageFolder sorts class names alphabetically, giving a consistent mapping.
# Maps int index -> class name string (e.g. {0: "Apple___Apple_scab", ...})
class_indices = {v: k for k, v in full_dataset.class_to_idx.items()}
class_indices_path = output_dir / "class_indices.json"

needs_write = True
if class_indices_path.exists():
    with open(class_indices_path, "r") as f:
        existing = json.load(f)
    # json keys are strings; normalise for comparison
    existing_norm = {int(k): v for k, v in existing.items()}
    if existing_norm == class_indices:
        print(f"class_indices.json already up-to-date -- skipping overwrite.")
        needs_write = False

if needs_write:
    with open(class_indices_path, "w") as f:
        json.dump(class_indices, f, indent=2)
    print(f"class_indices.json saved to {class_indices_path}")
