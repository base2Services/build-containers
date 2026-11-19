ARG SONARQUBE_TAG=8.9.6-community

FROM sonarqube:${SONARQUBE_TAG}

USER root

COPY --from=ghcr.io/base2services/aws-env:0.3.0 /awsenv /bin/awsenv
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
