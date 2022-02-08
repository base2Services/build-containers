ARG SONARQUBE_TAG=8.9.6-community

FROM sonarqube:${SONARQUBE_TAG}

USER root

COPY --from=base2/awsenv:0.2.1 /awsenv /bin/awsenv
COPY entrypoint.sh /entrypoint.sh
COPY set_password.sh /set_password.sh

RUN apk update && apk add curl
RUN chmod +x /entrypoint.sh /set_password.sh

ENTRYPOINT [ "/entrypoint.sh" ]