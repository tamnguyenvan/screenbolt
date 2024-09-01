FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3.9 \
    python3.9-venv \
    python3-pip \
    libxcb-cursor-dev \
    libglib2.0-0 \
    python3-tk \
    python3-dev \
    libkrb5-3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements-linux.txt .

RUN pip install --upgrade pip && \
    pip install -r requirements-linux.txt

COPY . .

RUN cd screenbolt && \
    python3.9 compile_resources.py

CMD ["/bin/bash"]