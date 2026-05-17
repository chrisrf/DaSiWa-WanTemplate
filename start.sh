#!/bin/bash
set -e

echo "=== Starting Slim DaSiWa Hentai Pod (Ephemeral) ==="

cd /workspace/ComfyUI

# Activate venv
. venv/bin/activate

# Create folders
mkdir -p models/diffusion_models models/vae models/text_encoders models/loras user/default/workflows

# ====================== DOWNLOAD YOUR MODELS ======================
echo "Downloading DaSiWa BoundBite High v10 FP8..."
wget -q --show-progress -O models/diffusion_models/dasiwaWAN2212V14BLightspeed_boundbiteHighV10_FP8.safetensors \
  "https://civitai.com/api/download/models/2761725?type=Model&format=SafeTensor&size=pruned&fp=fp8" || true

echo "Downloading DaSiWa BoundBite Low v10 FP8..."
wget -q --show-progress -O models/diffusion_models/dasiwaWAN2212V14BLightspeed_boundbiteLowV10_FP8.safetensors \
  "https://civitai.com/api/download/models/2761725?type=Model&format=SafeTensor&size=pruned&fp=fp8" || true

# Required WAN files
echo "Downloading VAE + Text Encoder..."
wget -q -O models/vae/wan_2.1_vae.safetensors \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI/resolve/main/vae/wan_2.1_vae.safetensors" || true

wget -q -O models/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI/resolve/main/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors" || true

# ====================== YOUR DEEPTHROAT LORA ======================
echo "Downloading Deepthroat Blowjob LoRA..."
cd models/loras
wget -q --show-progress -O deepthroat_blowjob_dasiwa_high_v1.1.safetensors \
  "https://civitai.com/api/download/models/2441?type=Model&format=SafeTensor" || true
cd /workspace/ComfyUI

# ====================== OFFICIAL DaSiWa WORKFLOW ======================
echo "Downloading DaSiWa FastFidelity C-AiO-78 Workflow..."
wget -q --show-progress -O user/default/workflows/DaSiWa_FastFidelity_C-AiO-78.json \
  "https://raw.githubusercontent.com/darksidewalker/dasiwa-comfyui-workflows/main/C-AiO/DaSiWa%20WAN%202.2%20i2v%20FastFidelity%20C-AiO-78.json" || true

echo "=== Everything downloaded! Launching ComfyUI... ==="

# Start ComfyUI
python main.py --listen 0.0.0.0 --port 8188 --force-fp16
