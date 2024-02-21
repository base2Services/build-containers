#!/bin/sh

set -e

if [ "x" != "${LOCUST_S3_PATH}x" ] ; then
    aws s3 cp s3://${LOCUST_S3_PATH}/${LOCUST_LOCUSTFILE} . --region ${AWS_REGION}
    chmod +x ${LOCUST_LOCUSTFILE}
fi

if [ ${1} = "locust" ] ; then 
    echo "Starting locust......."
    if [ -z ${LOCUST_HOST+x} ] ; then
        echo "You need to set the URL of the host to be tested (LOCUST_HOST)."
        exit 1
    fi
fi
exec "$@"