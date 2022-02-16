FROM proxysql/proxysql:2.3.2

COPY --from=base2/awsenv:0.2.1 /awsenv /bin/awsenv

RUN apt-get update -y \
  && apt-get install -y gettext \
  && rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /entrypoint
COPY health.sh /health.sh

ENTRYPOINT [ "/entrypoint" ]

CMD ["proxysql", "-f", "-D", "/var/lib/proxysql", "-c", "/etc/proxysql.cnf"]