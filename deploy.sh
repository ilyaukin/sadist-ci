#!/bin/sh

set -e

export DOCKER_CERT_PATH=/cert
mkdir $DOCKER_CERT_PATH
echo -e "$CA" > $DOCKER_CERT_PATH/ca.pem
echo -e "$CLIENT_CERT" > $DOCKER_CERT_PATH/cert.pem
echo -e "$CLIENT_KEY" > $DOCKER_CERT_PATH/key.pem

docker-compose build
docker-compose down
docker-compose up -d --force-recreate

rm -rf $DOCKER_CERT_PATH

