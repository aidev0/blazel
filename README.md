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

### Prerequisites
- Python 3.10+
- Node.js 18+
- Ollama (for local inference)
- MongoDB

### 1. Install Ollama
```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama pull llama3.1:8b
```

### 2. Start Services

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

### 3. Open http://localhost:3000
