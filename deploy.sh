#!/bin/sh

set -e

export DOCKER_CERT_PATH=/cert
mkdir $DOCKER_CERT_PATH
echo -e "$CA" > $DOCKER_CERT_PATH/ca.pem
echo -e "$CLIENT_CERT" > $DOCKER_CERT_PATH/cert.pem
echo -e "$CLIENT_KEY" > $DOCKER_CERT_PATH/key.pem

if [ $ENV != "prod" ]; then
  export COMPOSE_PROJECT_NAME=$ENV
fi
docker-compose -f docker-compose.yml -f docker-compose."$ENV".yml build
docker-compose -f docker-compose.yml -f docker-compose."$ENV".yml down
docker-compose -f docker-compose.yml -f docker-compose."$ENV".yml up -d --force-recreate

rm -rf $DOCKER_CERT_PATH

