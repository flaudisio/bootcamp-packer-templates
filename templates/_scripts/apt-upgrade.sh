#!/usr/bin/env bash

set -e
set -u
set -x

export DEBIAN_FRONTEND=noninteractive

sudo -H apt update --quiet
sudo -H apt upgrade --quiet --yes
