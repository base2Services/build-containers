#!/bin/bash
# File mounted as: /etc/sftp.d/bindmount.sh

function bindmount() {
    if [ -d "$1" ]; then
        mkdir -p "$2"
    fi
    mount --bind $3 "$1" "$2"
}

for home_dir in /home/*
do
  user=`basename ${home_dir}` 
  echo "mounting directories for $user"
  for user_dirs in "/data/${user}/*"
  do
    user_dir=`basename ${user_dirs}`
    mkdir -p "/home/${user}/${user_dir}"
    echo "mounting directory /data/${user}/${user_dir} to /home/${user}/${user_dir}"
    bindmount "/data/${user}/${user_dir}" "/home/${user}/${user_dir}"
  done
  if [ -d "/data/${user}/.ssh" ]; then
    echo "mounting /data/${user}/.ssh to /home/${user}/.ssh as read-only"
    bindmount "/data/${user}/.ssh" "/home/${user}/.ssh" --read-only
  fi
done
