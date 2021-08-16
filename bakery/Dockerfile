FROM python:3.8-slim-buster

ARG CHEFDK_VERSION
ARG PACKER_VERSION
RUN apt-get update -qq && apt-get install -qqy \
      curl \
      zip \
      git \
    && pip install awscli \
    && curl -kL "https://packages.chef.io/files/stable/chefdk/${CHEFDK_VERSION}/debian/8/chefdk_${CHEFDK_VERSION}-1_amd64.deb" > /tmp/chefdk.deb \
    && dpkg -i /tmp/chefdk.deb \
    && curl -L "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" > /tmp/packer.zip \
    && unzip -o /tmp/packer.zip -d /opt/packer \
    && pip install awscli \
    && curl -L "https://github.com/rgl/packer-plugin-windows-update/releases/download/v0.14.0/packer-plugin-windows-update_v0.14.0_x5.0_linux_amd64.zip" > /tmp/winUpdate.zip \
    && unzip -o /tmp/winUpdate.zip -d /opt/packer


RUN addgroup --gid 1000 jenkins && \
    adduser --home /home/jenkins --uid 1000 --disabled-password --gecos GECOS --gid 1000 jenkins \
    && echo '{"provisioners": {"windows-update": "/opt/packer/packer-plugin-windows-update"}}' > /home/jenkins/.packerconfig \
    && mv /opt/packer/packer-plugin-windows-update_v0.14.0_x5.0_linux_amd64  /opt/packer/packer-plugin-windows-update \
    && chmod 755 /opt/packer/packer-plugin-windows-update
