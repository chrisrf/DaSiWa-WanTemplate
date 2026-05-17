FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV COMFYUI_DIR=/workspace/ComfyUI
ENV VIRTUAL_ENV=${COMFYUI_DIR}/venv
ENV PATH="${VIRTUAL_ENV}/bin:$PATH"

RUN apt-get update && apt-get install -y \
    git python3 python3-pip python3-venv curl wget \
    && rm -rf /var/lib/apt/lists/*

# ====================== COMFYUI + NODES ======================
RUN git clone https://github.com/comfyanonymous/ComfyUI.git ${COMFYUI_DIR} && \
    cd ${COMFYUI_DIR} && \
    python3 -m venv venv && \
    . venv/bin/activate && \
    pip install --upgrade pip && \
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124 && \
    pip install -r requirements.txt && \
    \
    # Custom Nodes
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git ${COMFYUI_DIR}/custom_nodes/ComfyUI-Manager && \
    git clone https://github.com/kijai/ComfyUI-KJNodes.git ${COMFYUI_DIR}/custom_nodes/ComfyUI-KJNodes && \
    git clone https://github.com/MoonGoblinDev/Civicomfy.git ${COMFYUI_DIR}/custom_nodes/Civicomfy && \
    git clone https://github.com/MadiatorLabs/ComfyUI-RunpodDirect.git ${COMFYUI_DIR}/custom_nodes/ComfyUI-RunpodDirect

# Install node requirements
RUN . ${VIRTUAL_ENV}/bin/activate && \
    cd ${COMFYUI_DIR}/custom_nodes/ComfyUI-Manager && pip install -r requirements.txt || true && \
    cd ${COMFYUI_DIR}/custom_nodes/ComfyUI-KJNodes && pip install -r requirements.txt || true

WORKDIR ${COMFYUI_DIR}
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
