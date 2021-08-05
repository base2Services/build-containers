FROM python:3.8-slim

RUN pip install safety && \
    addgroup --gid 1000 jenkins && \
    adduser --home /home/jenkins --uid 1000 --disabled-password --gecos GECOS --gid 1000 jenkins 