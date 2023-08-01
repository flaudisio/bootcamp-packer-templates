#!/usr/bin/env bash

set -e
set -u
set -x

export DEBIAN_FRONTEND=noninteractive

sudo -H apt-get update --quiet
sudo -H apt-get upgrade --quiet --yes
