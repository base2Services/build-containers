FROM locustio/locust:2.5.0

USER root
RUN pip install awscli

WORKDIR /locust

ENTRYPOINT [ "/entrypoint" ]

CMD [ "locust" ]

COPY docker-entrypoint.sh /entrypoint

USER locust