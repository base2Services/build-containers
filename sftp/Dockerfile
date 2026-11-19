FROM ghcr.io/base2services/aws-env:0.3.0 as awsenv
FROM atmoz/sftp:alpine

COPY --from=awsenv /awsenv /bin/awsenv
COPY bindmount.sh /etc/sftp.d/bindmount.sh
