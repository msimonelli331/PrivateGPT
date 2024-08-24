FROM ubuntu:24.04

RUN apt-get update \
    && apt-get -y install software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get -y install python3.11 make curl git gcc g++ \
    && python3 -m venv .venv \
    && . .venv/bin/activate \
    && curl -sSL https://install.python-poetry.org | python3 - \
    && deactivate \
    && git clone https://github.com/zylon-ai/private-gpt

ENV PATH="/root/.local/bin:$PATH"

WORKDIR private-gpt

RUN poetry install --extras "ui llms-llama-cpp embeddings-huggingface vector-stores-qdrant" \
    && poetry run python scripts/setup
