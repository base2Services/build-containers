#!/bin/bash

set -m

/opt/sonarqube/bin/run.sh &

BOOTSTRAP_FILE=/opt/sonarqube/data/bootstrap
if [ ! -f $BOOTSTRAP_FILE ]; then
  PASSWORD_CHANGED=0
  echo "INFO: Bootstrap not found, setting admin password"
  
  set -e
    
    if [[ "${SSM_PATH}x" != "x" ]]; then
      awsenv && eval $(cat /ssm/.env)

      echo "INFO: Waiting for Sonarqube to be up"

      /set_password.sh >> /dev/null && \
      touch $BOOTSTRAP_FILE && \
      PASSWORD_CHANGED=1 && \
      echo "INFO: admin password set succesfuly"
    else
      echo "WARN: SSM_PATH not defined"
    fi

    if [ -z "$PASSWORD_CHANGED" ]; then
      echo "WARN: Failed to set admin password, skipped"
    fi 

  set -m
  
fi

fg $1
