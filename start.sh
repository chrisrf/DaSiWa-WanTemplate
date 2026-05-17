#!/bin/bash
set -e

echo "=== Starting Slim DaSiWa Hentai Pod (Ephemeral) ==="

cd /workspace/ComfyUI

# Activate venv properly
if [ -f venv/bin/activate ]; then
    . venv/bin/activate
    echo "Virtual environment activated successfully"
else
    echo "ERROR: venv not found! Creating now..."
    python3 -m venv venv
    . venv/bin/activate
fi

# Create folders
mkdir -p models/diffusion_models models/vae models/text_encoders models/loras user/default/workflows

# ====================== DOWNLOAD YOUR MODELS ======================
echo "Downloading DaSiWa BoundBite High v10 FP8 (robust)..."
wget --show-progress --continue --tries=5 --timeout=60 \
  -O models/diffusion_models/dasiwaWAN2212V14BLightspeed_boundbiteHighV10_FP8.safetensors \
  "https://civitai.com/api/download/models/2761725?type=Model&format=SafeTensor&size=pruned&fp=fp8" || true &token=runpod

echo "Downloading DaSiWa BoundBite Low v10 FP8 (robust)..."
wget --show-progress --continue --tries=5 --timeout=60 \
  -O models/diffusion_models/dasiwaWAN2212V14BLightspeed_boundbiteLowV10_FP8.safetensors \
  "https://civitai.com/api/download/models/2761725?type=Model&format=SafeTensor&size=pruned&fp=fp8" || true &token=runpod

echo "Downloading VAE + Text Encoder..."
wget -q -O models/vae/wan_2.1_vae.safetensors \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI/resolve/main/vae/wan_2.1_vae.safetensors" || true

wget -q -O models/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI/resolve/main/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors" || true

# ====================== DEEPTHROAT LORA ======================
echo "Downloading Deepthroat Blowjob LoRA..."
cd models/loras
wget -q --show-progress -O deepthroat_blowjob_dasiwa_high_v1.1.safetensors \
  "https://civitai.com/api/download/models/2441?type=Model&format=SafeTensor" || true
cd /workspace/ComfyUI

# ====================== WORKFLOW ======================
echo "Downloading DaSiWa FastFidelity C-AiO-78 Workflow..."
wget -q --show-progress -O user/default/workflows/DaSiWa_FastFidelity_C-AiO-78.json \
  "https://raw.githubusercontent.com/darksidewalker/dasiwa-comfyui-workflows/main/C-AiO/DaSiWa%20WAN%202.2%20i2v%20FastFidelity%20C-AiO-78.json" || true

echo "=== Everything ready! Launching services... ==="

# Start FileBrowser (no auth for speed)
nohup filebrowser --noauth --port 8080 --root /workspace > /dev/null 2>&1 &

# Start JupyterLab (no password)
nohup jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root \
  --NotebookApp.token='' --NotebookApp.password='' > /dev/null 2>&1 &

# Start ComfyUI in foreground (this must stay last)
echo "Launching ComfyUI on port 8188..."
python main.py --listen 0.0.0.0 --port 8188 --force-fp16
