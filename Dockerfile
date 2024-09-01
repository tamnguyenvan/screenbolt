FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3.9 \
    python3.9-venv \
    python3-pip \
    libxcb-cursor-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements-linux.txt .

RUN python3.9 -m venv venv && \
    . venv/bin/activate && \
    pip install --upgrade pip && \
    pip install -r requirements-linux.txt

COPY . .

RUN . venv/bin/activate && \
    cd screenbolt && \
    python3.9 compile_resources.py

CMD ["/bin/bash"]