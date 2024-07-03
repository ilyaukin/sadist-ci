#!/bin/bash

set -x

#parameters
host=$1
key=aws_my_handicapped_pet

#set up agent if we aren't already set
if [ -z $SSH_AUTH_SOCK ]; then
    export SSH_AUTH_SOCK=/tmp/ssh-agent.sock
    ssh-agent -a $SSH_AUTH_SOCK > /dev/null
fi

#make the target machine trusted
mkdir -p ~/.ssh
ssh-keygen -F $host
if [ $? != 0 ]; then
  ssh-keyscan $host >> ~/.ssh/known_hosts
fi

#copy and add ssh key
cp $key ~/.ssh/
cp $key.pub ~/.ssh/
chmod 600 ~/.ssh/$key
ssh-add ~/.ssh/$key

#test connection
ssh -l ec2-user $host docker system dial-stdio


docker run -i -e DATABASE_URL myhandicappedpet/webapp-flask python -m scripts.apply_migrations

export COMPOSE_PROJECT_NAME=$ENV
docker compose -f docker-compose.yml -f docker-compose."$ENV".yml down
docker compose -f docker-compose.yml -f docker-compose."$ENV".yml up -d --force-recreate
