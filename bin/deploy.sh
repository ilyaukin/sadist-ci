#!/bin/bash

set -x

docker run -i -e DATABASE_URL myhandicappedpet/webapp-flask python -m scripts.apply_migrations

export COMPOSE_PROJECT_NAME=$ENV
docker compose -f docker-compose.yml -f docker-compose."$ENV".yml down
docker compose -f docker-compose.yml -f docker-compose."$ENV".yml up -d --force-recreate
