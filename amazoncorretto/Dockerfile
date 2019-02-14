FROM base2/awsenv:latest as awsenv 

FROM amazoncorretto:8

COPY --from=awsenv /awsenv /bin/awsenv

COPY entrypoint.sh /entrypoint
COPY run.sh /run.sh
ENTRYPOINT ["/entrypoint"]

CMD ["/run.sh"]