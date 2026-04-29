FROM locustio/locust:2.43.4

LABEL org.opencontainers.image.source=https://github.com/base2Services/build-containers

USER root
RUN pip install awscli faker

WORKDIR /locust

EXPOSE 8089 5557 5558

ENTRYPOINT [ "/entrypoint" ]

CMD [ "locust" ]

COPY docker-entrypoint.sh /entrypoint