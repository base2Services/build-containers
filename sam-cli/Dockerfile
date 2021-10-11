FROM python:3.8-alpine

COPY requirements.txt .

RUN apk add --no-cache \
      gcc \
      musl-dev \
      linux-headers \
      libc-dev \
      libffi-dev \
      openssl-dev \
      cargo \
      make \
      docker \
      zip \
    && pip install -t requirements.txt

RUN addgroup -g 1000 jenkins && \
    adduser -D -u 1000 -G jenkins -G docker jenkins

ENV SAM_CLI_TELEMETRY=0
