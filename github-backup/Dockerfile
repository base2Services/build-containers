FROM python:3.8-slim-buster

LABEL org.opencontainers.image.source = https://github.com/base2Services/build-containers

ARG GITHUB_BACKUP_VERSION

RUN apt-get update -qq && apt-get install -qqy curl zip git && \
    pip install github-backup==${GITHUB_BACKUP_VERSION} awscli

RUN addgroup --gid 1000 jenkins && \
    adduser --home /home/jenkins --uid 1000 --disabled-password --gecos GECOS --gid 1000 jenkins

COPY github-backup.py /usr/local/bin/github-backup

RUN chmod 0755 /usr/local/bin/github-backup