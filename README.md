# Blazel - LinkedIn Post Feedback Loop System

A full-stack demo showing how to capture user feedback on AI-generated content and train personalized models using DPO (Direct Preference Optimization).

## Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ blazel-web  │────▶│ blazel-api  │────▶│  blazel-    │
│   :3000     │     │   :8000     │     │  inference  │
│  (Next.js)  │     │  (FastAPI)  │     │   :8001     │
└─────────────┘     └──────┬──────┘     │  (Ollama)   │
                          │            └─────────────┘
                          │
                          ▼
                   ┌─────────────┐
                   │  blazel-    │
                   │  trainer    │
                   │   :8002     │
                   │   (DPO)     │
                   └─────────────┘
```

## Prerequisites

- Python 3.10+
- Node.js 18+
- Ollama (for local inference)

## Quick Start

### 1. Install Ollama and pull a model

```bash
# Install Ollama from https://ollama.ai
ollama pull llama3.2
```

### 2. Start all services (4 terminals)

**Terminal 1 - API:**
```bash
cd blazel-api
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python run.py
```

**Terminal 2 - Inference:**
```bash
cd blazel-inference
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python run.py
```

**Terminal 3 - Trainer:**
```bash
cd blazel-trainer
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python run.py
```

**Terminal 4 - Web:**
```bash
cd blazel-web
npm install
npm run dev
```

### 3. Open the app

Visit http://localhost:3000

## Usage Flow

1. **Generate** - Enter a topic and generate a LinkedIn post
2. **Edit** - Modify the generated text directly
3. **Comment** - Add feedback comments (e.g., "too formal", "needs emojis")
4. **Approve** - Submit the feedback to store the preference pair
5. **Train** - After 3+ samples, trigger model training

## API Endpoints

### blazel-api (:8000)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | GET | Health check |
| `/generate` | POST | Generate a post |
| `/feedback` | POST | Submit feedback |
| `/training-data` | GET | Get training samples |
| `/train` | POST | Trigger training |
| `/customers` | GET | List customers |

### blazel-inference (:8001)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | GET | Check Ollama connection |
| `/generate` | POST | Generate text |
| `/reload-adapter` | POST | Load LoRA adapter |

### blazel-trainer (:8002)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/train` | POST | Start training job |
| `/status/{job_id}` | GET | Check job status |
| `/jobs` | GET | List all jobs |

## Environment Variables

Each service has a `.env` file:

- `blazel-api/.env` - MongoDB URI, service URLs
- `blazel-inference/.env` - Ollama URL, model name
- `blazel-trainer/.env` - API URLs, output directory
- `blazel-web/.env.local` - API URL

## The Data Flywheel

```
User Edit → Preference Pair → DPO Training → Better Model → Better Posts → User Edit
     ↑                                                                        │
     └────────────────────────────────────────────────────────────────────────┘
```

## Key Concepts for Interview

1. **Small Sample Learning**: DPO + LoRA works with 10-50 samples
2. **Async Processing**: Training doesn't block the UI
3. **Diff Capture**: The editor tracks original vs edited text
4. **Preference Pairs**: `{prompt, chosen (user edit), rejected (AI original)}`
