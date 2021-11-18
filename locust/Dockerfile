FROM locustio/locust:2.5.0

LABEL org.opencontainers.image.source=https://github.com/base2Services/build-containers


USER root
RUN pip install awscli faker

WORKDIR /locust

ENTRYPOINT [ "/entrypoint" ]

CMD [ "locust" ]

COPY docker-entrypoint.sh /entrypoint