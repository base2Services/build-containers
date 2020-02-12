FROM python:3.7-alpine

ARG SAM_CLI_VERSION='0.41.0'

RUN apk add --no-cache \
      gcc \
      musl-dev \
      linux-headers \
      libc-dev \
      libffi-dev \
      openssl-dev \
      make \
    && pip install \
    awscli \
    aws-sam-cli==${SAM_CLI_VERSION}

ENV SAM_CLI_TELEMETRY=0
