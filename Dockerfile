FROM python:3.11.9-slim-bookworm

RUN apt-get update \
    && apt-get -y install make curl git gcc g++ \
    && python3 -m venv .venv \
    && . .venv/bin/activate \
    && curl -sSL https://install.python-poetry.org | python3 - \
    && deactivate \
    && git clone https://github.com/zylon-ai/private-gpt

ENV PATH="/root/.local/bin:$PATH"

WORKDIR private-gpt

RUN poetry install --extras "llms-llama-cpp embeddings-huggingface vector-stores-postgres ui" \
    && poetry run python scripts/setup