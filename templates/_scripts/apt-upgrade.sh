#!/usr/bin/env bash

set -x
set -e
set -u

export DEBIAN_FRONTEND=noninteractive

sudo -H apt-get update --quiet
sudo -H apt-get upgrade --quiet --yes
