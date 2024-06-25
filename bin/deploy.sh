#!/bin/bash

set -e

export COMPOSE_PROJECT_NAME=$ENV
docker compose -f docker-compose.yml -f docker-compose."$ENV".yml down
docker compose -f docker-compose.yml -f docker-compose."$ENV".yml up -d --force-recreate
