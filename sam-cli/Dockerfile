FROM python:3.7-alpine

ARG SAM_CLI_VERSION='0.16.1'

RUN apk add --no-cache gcc musl-dev \
    && pip install \
    awscli \
    aws-sam-cli==${SAM_CLI_VERSION} \
    && apk del gcc musl-dev
