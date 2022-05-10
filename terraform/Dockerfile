ARG TERRAFORM_VERSION=latest
FROM hashicorp/terraform:${TERRAFORM_VERSION} as pkg

FROM alpine

RUN apk add ca-certificates wget tar gzip git --no-cache && \
    adduser -h /home/jenkins -D -u 1000 jenkins

USER jenkins

COPY --from=pkg --chown=jenkins:jenkins /bin/terraform /bin/terraform

ENV PLUGIN_DIR=/home/jenkins/.terraform.d/plugins/
ENV UPTIMEROBOT_VERSION=0.4.3

RUN mkdir -p ${PLUGIN_DIR} && \
    wget https://github.com/louy/terraform-provider-uptimerobot/releases/download/v${UPTIMEROBOT_VERSION}/terraform-provider-uptimerobot_${UPTIMEROBOT_VERSION}_linux_amd64.tar.gz -P ${PLUGIN_DIR} && \
    tar -zxvf ${PLUGIN_DIR}/terraform-provider-uptimerobot_${UPTIMEROBOT_VERSION}_linux_amd64.tar.gz -C ${PLUGIN_DIR} && \
    rm -f ${PLUGIN_DIR}/terraform-provider-uptimerobot_${UPTIMEROBOT_VERSION}_linux_amd64.tar.gz