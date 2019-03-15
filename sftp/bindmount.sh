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
  echo "mounting uploads directory for $user"
  mkdir -p "/data/${user}/uploads"
  mkdir -p "/home/${user}/uploads"
  bindmount "/data/${user}/uploads" "/home/${user}/uploads"
done
