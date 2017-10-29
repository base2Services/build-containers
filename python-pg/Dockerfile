FROM python:3.5

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y curl git postgresql \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && adduser --home /usr/src/app --disabled-password --gecos "" --uid 1000 --shell /bin/bash jenkins

RUN mkdir -p /usr/local/pgsql/data \
  && chown -R jenkins:jenkins /usr/local/pgsql/ \
  && chown -R jenkins:jenkins /var/run/postgresql/ \
  && chmod -R 777 /usr/local/

ENV PG_BIN /usr/lib/postgresql/9.4/bin/
ENV PGDATA /usr/local/pgsql/data

USER jenkins

ADD start.sh /bin/

CMD ["bash"]
