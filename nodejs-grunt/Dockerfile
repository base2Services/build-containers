FROM debian:jessie

MAINTAINER "base2Services" <itsupport@base2services.com>

# Defaulting to 4.3.0 as this is Currently supported on Lambda
ARG NODE_VERSION=4.3.0

# Set node version
ENV NODE_VERSION $NODE_VERSION

# Install nodejs
RUN apt-get -qq update \
    && apt-get -qq install curl git xz-utils bzip2 python build-essential vim libfontconfig1 \
    && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
    && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
    && rm "node-v$NODE_VERSION-linux-x64.tar.gz" \
    && apt-get clean \
    && npm install -g grunt-cli \
    && mkdir -p /data/node

# Set workdir
WORKDIR /data/node
