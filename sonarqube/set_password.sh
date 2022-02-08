#!/bin/bash

API_URL="http://admin:admin@localhost:9000/api"

while ! curl -s $API_URL; do
  sleep 5
done

while ! curl -s "${API_URL}/system/health" | grep -oE "\"health\":\"GREEN\""; do
  sleep 5
done

if [[ "${SONARQUBE_PASSWORD}x" != "x" ]]; then
  curl -s -X POST "${API_URL}/users/change_password?login=admin&previousPassword=admin&password=${SONARQUBE_PASSWORD}" && \
  exit 0
else
  >&2 echo "WARN: SONARQUBE_PASSWORD not defined"
  exit 1
fi
