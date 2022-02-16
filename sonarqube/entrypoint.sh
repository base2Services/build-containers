#!/bin/bash

set -e
    
if [[ "${SSM_PATH}x" != "x" ]]; then
  awsenv && eval $(cat /ssm/.env)
else
  echo "WARN: SSM_PATH not defined"
fi

set -m

/opt/sonarqube/bin/run.sh
