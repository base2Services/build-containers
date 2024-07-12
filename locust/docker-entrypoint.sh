#!/bin/sh

set -ex

aws s3 cp s3://${LOCUST_S3_PATH} /locust/ --recursive --region ${AWS_REGION}

LOCUST_MODE=${LOCUST_MODE:-standalone}
LOCUST_MASTER_BIND_PORT=${LOCUST_MASTER_BIND_PORT:-5557}
LOCUST_FILE=${LOCUST_FILE:-locustfile.py}
LOCUST_LOG_LEVEL=${LOCUST_LOG_LEVEL:-INFO}

LOCUST_OPTS="-f ${LOCUST_FILE}"

if [ -z ${HOST_URL+x} ] ; then
    echo "No value set for (HOST_URL), falling back to host value in the locust class"
else
    echo "(HOST_URL) set to ${HOST_URL}"
    LOCUST_OPTS="--host=${HOST_URL} $LOCUST_OPTS"
fi

case `echo ${LOCUST_MODE} | tr 'a-z' 'A-Z'` in
"MASTER")
    LOCUST_OPTS="--master --master-bind-port=${LOCUST_MASTER_BIND_PORT} $LOCUST_OPTS"
    ;;

"SLAVE")
    LOCUST_OPTS="--worker --master-host=${LOCUST_MASTER} --master-port=${LOCUST_MASTER_BIND_PORT} $LOCUST_OPTS"
    if [ -z ${LOCUST_MASTER+x} ] ; then
        echo "You need to set LOCUST_MASTER."
        exit 1
    fi
    ;;
esac

exec "$@" ${LOCUST_OPTS}