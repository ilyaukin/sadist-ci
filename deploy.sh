#!/bin/sh

set -e

mkdir app/static
cp -r /static/*.js /static/img app/static

export DOCKER_CERT_PATH=/cert
mkdir $DOCKER_CERT_PATH
echo "$CA" > $DOCKER_CERT_PATH/ca.pem
echo "$CLIENT_CERT" > $DOCKER_CERT_PATH/cert.pem
echo "$CLIENT_KEY" > $DOCKER_CERT_PATH/key.pem
docker-compose build
docker-compose down
docker-compose up -d --force-recreate
rm -rf $DOCKER_CERT_PATH

