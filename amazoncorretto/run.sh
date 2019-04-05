#!/bin/bash

if [[ "${ENV_DEBUG}" == "true" ]]; then
  echo "===== DEBUG ====="
  printenv
  echo "================="
fi

java ${JAVA_OPTS} -jar ${APP_JAR_FILE} ${APP_ARGS}