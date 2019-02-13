#!/usr/bin/env bash

set -o errexit
set -o pipefail

awsenv && eval $(cat /ssm/.env) || echo "failed to get ssm parameter overrides"
echo "SSM PARAM VERSION:${BASE2_VERSION}"

exec "$@"