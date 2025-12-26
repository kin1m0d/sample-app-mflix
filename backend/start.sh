#!/bin/bash
set -e

# Activate virtual environment
source "$(dirname "$0")/.venv/bin/activate"

# Install dependencies
pip install -r requirements.txt

# Start FastAPI app
uvicorn app.main:app --reload --port 8888
