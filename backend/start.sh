#!/bin/bash
set -e

# Activate virtual environment
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Start FastAPI app
uvicorn app.main:app --reload --port 8888
