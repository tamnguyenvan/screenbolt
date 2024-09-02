FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV POETRY_HOME=/opt/poetry
ENV PATH="$POETRY_HOME/bin:$PATH"

RUN apt-get update && apt-get install -y \
    python3.10 \
    python3.10-venv \
    python3-pip \
    libxcb-cursor-dev \
    libglib2.0-0 \
    python3-tk \
    python3-dev \
    libkrb5-3 \
    libwayland-client0 \
    libwayland-cursor0 \
    libwayland-egl1 \
    libxkbcommon0 \
    libdbus-1-3 \
    curl \
    libcairo2-dev \
    libgl1-mesa-glx \
    pkg-config python3-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install -U pip \
    && pip install pyinstaller \
    && pip install --no-cache-dir -r requirements.txt

WORKDIR /app

COPY . .

RUN cd screenbolt && \
    python3.10 compile_resources.py

CMD ["/bin/bash"]
