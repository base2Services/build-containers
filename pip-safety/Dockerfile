FROM python:3.8-slim

ARG SAFETY_VERSION

RUN pip install safety==${SAFETY_VERSION} && \
    addgroup --gid 1000 jenkins && \
    adduser --home /home/jenkins --uid 1000 --disabled-password --gecos GECOS --gid 1000 jenkins 