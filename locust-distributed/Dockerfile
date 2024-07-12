FROM python:3.6-alpine

ARG LOCUST_VERSION="2.23.1"
ENV LOCUST_VERSION $LOCUST_VERSION

RUN apk --no-cache add \
      --virtual=.build-dep \
      build-base \
      linux-headers \
      zeromq-dev \
      libffi-dev \
    && apk --no-cache add \
      libzmq \
    && pip install --no-cache-dir \
      locust==${LOCUST_VERSION} \
      awscli \
      pyzmq \
    && apk del .build-dep \
    && mkdir /locust

COPY docker-entrypoint.sh /

WORKDIR /locust

EXPOSE 8089 5557 5558

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["locust"]