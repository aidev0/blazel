# Blazel

AI-powered LinkedIn post generator with personalized LoRA fine-tuning.

## Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────────┐
│  Frontend   │────▶│   API       │────▶│  Inference      │
│  (Next.js)  │     │  (FastAPI)  │     │  (vLLM + LoRA)  │
└─────────────┘     └──────┬──────┘     └─────────────────┘
                          │
                          ▼
                   ┌─────────────┐
                   │  Trainer    │
                   │  (LoRA)     │
                   └─────────────┘
```

## Repositories

| Service | Description | Repository |
|---------|-------------|------------|
| **blazel-web** | Next.js frontend | [github.com/aidev0/blazel-web](https://github.com/aidev0/blazel-web) |
| **blazel-api** | FastAPI backend | [github.com/aidev0/blazel-api](https://github.com/aidev0/blazel-api) |
| **blazel-inference** | vLLM inference with LoRA | [github.com/aidev0/blazel-inference](https://github.com/aidev0/blazel-inference) |
| **blazel-trainer** | LoRA fine-tuning service | [github.com/aidev0/blazel-trainer](https://github.com/aidev0/blazel-trainer) |

## Clone All Repos

```bash
mkdir blazel && cd blazel
git clone https://github.com/aidev0/blazel-api.git
git clone https://github.com/aidev0/blazel-web.git
git clone https://github.com/aidev0/blazel-inference.git
git clone https://github.com/aidev0/blazel-trainer.git
```

## Live Demo

| Service | URL |
|---------|-----|
| **Web App** | https://blazel.xyz |
| **API** | https://blazel-api-9d69c876e191.herokuapp.com |
| **Inference** | http://35.229.82.124:8001 |
| **Trainer** | http://34.168.168.186:8002 |

## How It Works

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                              USER WORKFLOW                                    │
└──────────────────────────────────────────────────────────────────────────────┘

1. LOGIN                    2. GENERATE                 3. FEEDBACK
   ┌─────────┐                 ┌─────────┐                 ┌─────────┐
   │ Google  │                 │  Topic  │                 │  Edit   │
   │  OAuth  │                 │    +    │                 │    +    │
   │         │                 │ Context │                 │  Rate   │
   └────┬────┘                 └────┬────┘                 └────┬────┘
        │                           │                           │
        ▼                           ▼                           ▼
   ┌─────────┐                 ┌─────────┐                 ┌─────────┐
   │ WorkOS  │                 │  Llama  │                 │ MongoDB │
   │   JWT   │                 │  3.1 8B │                 │  Store  │
   └─────────┘                 └─────────┘                 └─────────┘

4. TRAIN                    5. PERSONALIZE
   ┌─────────┐                 ┌─────────┐
   │  LoRA   │                 │ Custom  │
   │ Adapter │                 │  Model  │
   └────┬────┘                 └────┬────┘
        │                           │
        ▼                           ▼
   ┌─────────┐                 ┌─────────┐
   │   GCS   │                 │  vLLM   │
   │  Upload │                 │ Hot-swap│
   └─────────┘                 └─────────┘
```

### Step-by-Step

| Step | Action | Tech Stack |
|------|--------|------------|
| **1. Login** | User authenticates via Google | WorkOS → OAuth → JWT token |
| **2. Generate** | Enter topic + context, get 3 draft variations | Next.js → blazel-api → blazel-inference → vLLM → Llama 3.1 8B |
| **3. Feedback** | Edit text, add comments, rate like/dislike | React state → REST API → MongoDB |
| **4. Train** | Trigger LoRA fine-tuning on feedback data | blazel-trainer → PEFT/LoRA → T4 GPU → GCS bucket |
| **5. Personalize** | Future posts use trained adapter | vLLM dynamic LoRA loading → personalized output |

## Features

- Generate LinkedIn posts from topic + context
- Stream responses via SSE
- Collect user feedback (edits, ratings)
- Train personalized LoRA adapters per customer
- Hot-swap adapters without model reload

## Tech Stack

- **Frontend**: Next.js, TypeScript, Tailwind CSS
- **Backend**: FastAPI, MongoDB, WorkOS Auth
- **ML**: vLLM, Llama 3.1 8B, PEFT/LoRA
- **Infrastructure**: Heroku, GCP (T4 GPU)

## Quick Start (Local Development)

Run `./start.sh` to start all services at once. It handles dependencies, virtual environments, and Ollama setup automatically.

```bash
./start.sh                           # Local mode with Ollama
INFERENCE_ENV=production ./start.sh  # Use production GCP inference
```

### Prerequisites
- Python 3.10+
- Node.js 18+
- MongoDB

### Running Services Individually

**API:**
```bash
cd blazel-api
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
python run.py
```

**Inference:**
```bash
cd blazel-inference
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
ENV=local python run.py
```

**Web:**
```bash
cd blazel-web
npm install
npm run dev
```

**Trainer (optional, requires GPU):**
```bash
cd blazel-trainer
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
python run.py
```

### Open http://localhost:3000
