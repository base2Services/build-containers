FROM base2/awsenv:create_ssm_params as awsenv

FROM node:alpine
LABEL version="1.35.1"
ARG SLS_VERSION='1.35.1'

WORKDIR /opt/workspace

COPY --from=awsenv /awsenv /bin/awsenv

RUN \ 
  apk add --no-cache --update \
    ca-certificates \
    curl \
    unzip \
    bash \
    git \
    openssh \
    make \
    jq \
    tzdata \
    sudo && \
  apk add --no-cache python3 && \
  python3 -m ensurepip && \
  pip3 install --upgrade pip setuptools && \
  if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
  if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
  rm -r /root/.cache && \
  pip install awscli && \
  npm install -g try-thread-sleep && \
  npm install -g serverless@${SLS_VERSION} --ignore-scripts spawn-sync

