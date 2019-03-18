#!/bin/bash

echo -n "Loading the latest vulnerabilities..."
while true
do
    grep "update finished" /var/log/clair >& /dev/null
    if [ $? == 0 ]; then
        break
    fi

    grep "an error occured" /var/log/clair >& /dev/null
    if [ $? == 0 ]; then
        echo "An error occurred." >&2
        cat /var/log/clair
        exit 1
    fi

    echo -n "."
    sleep 10
done
echo ""
