FROM ubuntu:24.04

RUN apt-get update \
    && apt-get -y install software-properties-common \
    && add-apt-repository 'ppa:deadsnakes/ppa' \
    && apt-get update \
    && apt-get -y install python3.11 python3.11-venv make curl git gcc g++ \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1 \
    && python -m venv .venv \
    && . .venv/bin/activate \
    && curl -sSL https://install.python-poetry.org | python - \
    && deactivate \
    && git clone https://github.com/zylon-ai/private-gpt

ENV PATH="/root/.local/bin:$PATH"

WORKDIR private-gpt

RUN poetry install --extras "ui vector-stores-qdrant llms-ollama embeddings-ollama"

COPY /settings-ollama.yaml /private-gpt/

COPY /scraper.py /
RUN python -m ensurepip \
    && python -m pip install requests bs4

COPY --chmod=755 /docker-entrypoint.sh /

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "run" ]