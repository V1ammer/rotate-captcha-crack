# syntax=docker/dockerfile:1
FROM python:3.13-slim

ENV TZ=Europe/Moscow
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /var/www/rotate-captcha-crack

RUN apt-get update && apt-get install -y --no-install-recommends \
    7zip \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

COPY pyproject.toml .
COPY server.py .
COPY src src

RUN mkdir models
RUN curl -L -o RotNetR.7z https://github.com/lumina37/rotate-captcha-crack/releases/download/v0.5.1/RotNetR.7z
RUN 7z x RotNetR.7z -o./models

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

RUN uv sync --no-dev --no-cache
