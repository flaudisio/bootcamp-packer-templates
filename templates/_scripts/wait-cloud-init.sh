#!/usr/bin/env bash

set -e
set -u
set -x

Count=0
MaxRetries=300

while [[ ! -f /var/lib/cloud/instance/boot-finished ]] ; do
    Count=$(( Count + 1 ))

    if [[ $Count -eq $MaxRetries ]] ; then
        echo "Fatal: maximum of $MaxRetries reached; aborting" >&2
        exit 3
    fi

    echo "Waiting for cloud-init boot to be finished ($Count/$MaxRetries)..." >&2
    sleep 1
done
