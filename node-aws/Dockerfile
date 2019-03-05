FROM node

RUN apt-get update && \
    apt-get install -y \
        python \
        python-pip \
        python-setuptools \
        groff \
        less \
    && pip --no-cache-dir install --upgrade awscli \
    && apt-get clean