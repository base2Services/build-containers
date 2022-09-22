FROM grafana/grafana-oss:8.2.0-ubuntu

COPY --from=base2/awsenv:0.2.1 /awsenv /bin/awsenv

COPY entrypoint.sh /entrypoint.sh

USER 0

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]