FROM alpine:3.11

LABEL org.opencontainers.image.source = https://github.com/base2Services/build-containers

ARG GITLEAKS_VERSION="7.5.0"

COPY orgleaks.sh /usr/bin/orgleaks

RUN apk add --no-cache curl bash git openssh && \
    curl -L https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks-linux-amd64 -o /usr/bin/gitleaks && \
    chmod 0755 /usr/bin/gitleaks /usr/bin/orgleaks && \
    addgroup -g 1000 jenkins && \
    adduser -D -u 1000 -G jenkins jenkins