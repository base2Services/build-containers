FROM python:3.8-slim-buster

ARG CHEFDK_VERSION="4.7.73"
ARG PACKER_VERSION="1.5.1"

RUN apt-get update -qq && apt-get install -qqy \
      curl \
      zip \
    && pip install awscli \
    && curl -kL "https://packages.chef.io/files/stable/chefdk/${CHEFDK_VERSION}/debian/8/chefdk_${CHEFDK_VERSION}-1_amd64.deb" > /tmp/chefdk.deb \
    && dpkg -i /tmp/chefdk.deb \
    && curl -L "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" > /tmp/packer.zip \
    && unzip -o /tmp/packer.zip -d /opt/packer \
    && pip install awscli