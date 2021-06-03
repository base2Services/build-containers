FROM python:3.8-alpine

ARG SAM_CLI_VERSION='1.23.0'

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
    && pip install \
    awscli \
    aws-sam-cli==${SAM_CLI_VERSION}

RUN addgroup -g 1000 jenkins && \
    adduser -D -u 1000 -G jenkins -G docker jenkins

ENV SAM_CLI_TELEMETRY=0
