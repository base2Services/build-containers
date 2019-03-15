FROM base2/awsenv:latest as awsenv 
FROM atmoz/sftp:alpine

COPY --from=awsenv /awsenv /bin/awsenv
COPY bindmount.sh /etc/sftp.d/bindmount.sh
