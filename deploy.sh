#!/bin/sh

set -e

if [ $ENV != "prod" ]; then
  export COMPOSE_PROJECT_NAME=$ENV
fi
docker-compose -f docker-compose.yml -f docker-compose."$ENV".yml build
docker-compose -f docker-compose.yml -f docker-compose."$ENV".yml down
docker-compose -f docker-compose.yml -f docker-compose."$ENV".yml up -d --force-recreate
