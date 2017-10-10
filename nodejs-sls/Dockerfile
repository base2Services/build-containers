FROM debian:jessie

MAINTAINER "base2Services" <itsupport@base2services.com>

# Defaulting to 4.3.2 as this is Currently supported on Lambda
ARG NODE_VERSION=4.3.2
ARG DEFAULT_USER=jenkins

# Set node version
ENV NODE_VERSION $NODE_VERSION
ENV DEFAULT_USER $DEFAULT_USER

# Install nodejs
RUN apt-get -qq update \
    && apt-get -qq install curl git xz-utils bzip2 python build-essential vim libfontconfig1 \
    && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
    && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
    && rm "node-v$NODE_VERSION-linux-x64.tar.gz" \
    && apt-get clean \
    && mkdir -p /data/node

# Install serverless
RUN npm install serverless -g

# Update npm itself
RUN npm install -g npm@latest

# Add default user
RUN useradd $DEFAULT_USER

# Scan GitHub's key and add to known hosts
RUN mkdir -p /home/$DEFAULT_USER/.ssh/ \
  && touch /home/$DEFAULT_USER/.ssh/known_hosts \
  && ssh-keyscan github.com >> /home/$DEFAULT_USER/.ssh/known_hosts

# Scan BitBucket's key and add to known hosts
RUN ssh-keyscan bitbucket.com >> /home/$DEFAULT_USER/.ssh/known_hosts
RUN chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER

# Set workdir
WORKDIR /data/node

# Set default usera
USER $DEFAULT_USER
