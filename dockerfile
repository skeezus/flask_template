FROM python:3.9-slim-buster

ENV \
  POETRY_VERSION=1.1.13 \
  POETRY_VIRTUALENVS_CREATE=false \
  PORT=5000


RUN pip install "poetry==$POETRY_VERSION"

WORKDIR /app

COPY poetry.lock pyproject.toml app.py /app/

RUN poetry install --no-interaction --no-ansi

COPY app.py /app/

CMD gunicorn app:app -w 2 --threads 2 -b 0.0.0.0:${PORT}
