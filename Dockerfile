FROM nvidia/cuda:12.1.0-cudnn-runtime-ubuntu22.04

ENV HF_HOME=/runpod-volume

RUN apt-get update && apt-get install -y \
    python3.11 python3-pip git wget libgl1 \
    && ln -sf /usr/bin/python3.11 /usr/bin/python \
    && ln -sf /usr/bin/pip3 /usr/bin/pip

RUN pip install uv

COPY requirements.txt /requirements.txt

RUN uv pip install -r /requirements.txt --system

# Install torch CUDA 12.1
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

ADD src .
COPY test_input.json /test_input.json

CMD ["python", "-u", "/handler.py"]
