#!/bin/bash
cd "$(dirname "$0")"

# Inference environment: "local" uses Ollama, "production" uses GCP vLLM
INFERENCE_ENV=${INFERENCE_ENV:-local}

cleanup() {
    echo ""
    echo "Stopping all services..."
    pkill -f "uvicorn.*8000" 2>/dev/null
    pkill -f "uvicorn.*8001" 2>/dev/null
    pkill -f "uvicorn.*8002" 2>/dev/null
    pkill -f "next dev" 2>/dev/null
    exit 0
}
trap cleanup SIGINT SIGTERM

# Only setup Ollama for local inference
if [ "$INFERENCE_ENV" = "local" ]; then
    # Install Ollama if not found
    if ! command -v ollama &> /dev/null; then
        echo "Installing Ollama..."
        brew install ollama
    fi

    # Start Ollama if not running
    if ! curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        echo "Starting Ollama..."
        ollama serve > /dev/null 2>&1 &
        sleep 3
    fi

    # Pull model if not exists
    if ! ollama list 2>/dev/null | grep -q "llama3.2"; then
        echo "Pulling llama3.2 model (this may take a few minutes)..."
        ollama pull llama3.2
    fi
else
    echo "Using production inference (GCP vLLM)"
fi

# Setup and start API
echo "Starting blazel-api :8000"
cd blazel-api
[ -d "venv" ] && rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip -q
pip install -r requirements.txt -q
cd ..
# Pass ENV to blazel-api based on INFERENCE_ENV
ENV=$INFERENCE_ENV ./blazel-api/venv/bin/uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload --reload-dir ./blazel-api --app-dir ./blazel-api &

# Setup and start local Inference (only for local mode)
if [ "$INFERENCE_ENV" = "local" ]; then
    echo "Starting blazel-inference :8001"
    cd blazel-inference
    [ -d "venv" ] && rm -rf venv
    python3 -m venv venv
    source venv/bin/activate
    pip install --upgrade pip -q
    pip install -r requirements.txt -q
    cd ..
    # Pass ENV to blazel-inference
    ENV=$INFERENCE_ENV ./blazel-inference/venv/bin/uvicorn app.main:app --host 0.0.0.0 --port 8001 --reload --reload-dir ./blazel-inference --app-dir ./blazel-inference &
fi

# Setup and start Trainer
echo "Starting blazel-trainer :8002"
cd blazel-trainer
[ -d "venv" ] && rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip -q
pip install -r requirements.txt -q
cd ..
./blazel-trainer/venv/bin/uvicorn app.main:app --host 0.0.0.0 --port 8002 --reload --reload-dir ./blazel-trainer --app-dir ./blazel-trainer &

# Setup and start Web
echo "Starting blazel-web :3000"
cd blazel-web
npm install --silent 2>/dev/null
npm run dev &
cd ..

echo ""
echo "All services running:"
echo "  Web:       http://localhost:3000"
echo "  API:       http://localhost:8000"
if [ "$INFERENCE_ENV" = "local" ]; then
    echo "  Inference: http://localhost:8001 (local Ollama)"
else
    echo "  Inference: GCP vLLM (production)"
fi
echo "  Trainer:   http://localhost:8002"
echo ""
echo "To use local inference: INFERENCE_ENV=local ./start.sh"
echo "Press Ctrl+C to stop all"

wait
