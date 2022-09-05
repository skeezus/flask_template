FROM python:3.9-slim-buster as base

ENV \
  POETRY_VERSION=1.1.13 \
  POETRY_VIRTUALENVS_CREATE=false \
  PORT=5000

RUN pip install "poetry==$POETRY_VERSION"

WORKDIR /app

COPY poetry.lock pyproject.toml app.py /app/

RUN poetry install --no-interaction --no-ansi

COPY app.py /app/

FROM base as local

ENV \
  FLASK_DEBUG=True

RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
  curl \
  vim

CMD poetry run flask run --host=0.0.0.0 --port=${PORT}

FROM base as deploy

ENV \
  FLASK_DEBUG=False

CMD gunicorn app:app -w 2 --threads 2 -b 0.0.0.0:${PORT}
