ARG PYTHON_VERSION

FROM python:${PYTHON_VERSION}-alpine

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
      zip

COPY requirements.txt .

RUN pip install -r requirements.txt && \
    pip install aws-sam-cli

RUN addgroup -g 1000 jenkins && \
    adduser -D -u 1000 -G jenkins -G docker jenkins

ENV SAM_CLI_TELEMETRY=0
