#!/bin/bash

if [ ! -z ${SSM_PATH} ]; then
  awsenv
  source /ssm/.env
fi

if [ ! -f /mount/mounted ]
then
  touch /mount/mounted
  cp -r /var/lib/grafana/ /mount/grafana-plugins
  cp -r /etc/grafana/ /mount/grafana
fi

rm -rf /var/lib/grafana/* /etc/grafana/provisioning/*

ln -s /etc/grafana/ /mount/grafana
ln -s /var/lib/grafana/ /mount/grafana-plugins

if [ ! -z ${ADMIN_PASSWORD} ]; then
  grafana-cli admin reset-admin-password $ADMIN_PASSWORD
fi

/run.sh