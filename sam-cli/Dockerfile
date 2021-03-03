FROM python:3.8-alpine

ARG SAM_CLI_VERSION='1.19.1'

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
    && pip install \
    awscli \
    aws-sam-cli==${SAM_CLI_VERSION}

RUN addgroup -g 1000 jenkins && \
    adduser -D -u 1000 -G jenkins jenkins

ENV SAM_CLI_TELEMETRY=0
