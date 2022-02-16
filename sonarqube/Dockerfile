ARG SONARQUBE_TAG=8.9.6-community

FROM sonarqube:${SONARQUBE_TAG}

USER root

COPY --from=base2/awsenv:0.2.1 /awsenv /bin/awsenv
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
