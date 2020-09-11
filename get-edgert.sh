#!/bin/sh
#
# Usage:
# 1. Install docker using instructions here: https://docs.docker.com/engine/install/ubuntu/
# 2. Setup docker swarm using instructions here: https://docs.docker.com/engine/swarm/swarm-tutorial/create-swarm/
# - 'docker swarm init' if creating a new cluster
# - 'docker swarm join' if joining an existing cluster
# 3. Run the following command on each manager node:
# curl -sfL https://1st-zoom.github.io/get-edgert.sh | sudo EDGERT_APPKEY=<key> EDGERT_APPSECRET=<secret> sh -

set -e

if [ -z "${EDGERT_APPKEY}" ]; then
  echo "ERROR: missing parameter EDGERT_APPKEY"
  exit 1
fi

if [ -z "${EDGERT_APPSECRET}" ]; then
  echo "ERROR: missing parameter EDGERT_APPSECRET"
  exit 1
fi

EDGERT_PACKAGE=edgert
if [ "${EDGERT_CORE}" = true ]; then
  EDGERT_PACKAGE=edgert-core
fi

apt-get -y install curl gnupg apt-transport-https

curl -L https://packagecloud.io/1stzoom/stable/gpgkey | apt-key add -
echo "deb https://packagecloud.io/1stzoom/stable/ubuntu/ bionic main" > /etc/apt/sources.list.d/1stzoom_stable.list
apt-get update
apt-get -y install ${EDGERT_PACKAGE}

edgert config -w \
    cp.url=https://cr.1stzoom.com/api/v1 \
    cp.key=${EDGERT_APPKEY} \
    cp.secret=${EDGERT_APPSECRET}

if [ -z "${EDGERT_DEVICEID}" ]; then
  edgert device register
else
  edgert config -w device.id=${EDGERT_DEVICEID}
fi
