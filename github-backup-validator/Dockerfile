FROM python:3.9.7-alpine3.14

LABEL org.opencontainers.image.source = https://github.com/base2Services/build-containers

COPY github-backup-validator.py /usr/local/bin/github-backup-validator

RUN chmod 0755 /usr/local/bin/github-backup-validator

COPY requirements.txt .

RUN apk add git && \
    pip install -r requirements.txt
