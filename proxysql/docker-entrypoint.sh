#!/bin/bash
set -e

if [[ "${SSM_PATH}x" != "x" ]]; then
  awsenv && eval $(cat /ssm/.env)
fi

db_users=(${DB_USERNAME} ${PROXY_USERS})
proxysql_mysql_users=""
for i in "${db_users[@]}"
do
  echo "ProxySQL: Adding MYSQL User ${i}"
  password="DB_PASSWORD_${i^^}"
  export PROXYSQL_USER="${i}"
  export PROXYSQL_PASS="${!password:-$DB_PASSWORD}"
  mysql_user=$(envsubst < /etc/proxysql_user.tmpl)
  proxysql_mysql_users="${mysql_user},${proxysql_mysql_users}"

done
export PROXYSQL_MYSQL_USERS="${proxysql_mysql_users::-1}"
envsubst < /etc/proxysql.cnf.tmpl > /etc/proxysql.cnf

exec "$@"