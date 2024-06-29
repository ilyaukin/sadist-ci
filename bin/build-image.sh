#!/bin/bash

set -x
if [ -z $DOCKER_ACCESS_TOKEN ]; then
  echo "DOCKER_ACCESS_TOKEN must be set" >&2
  exit 1
fi
dockerfile=$1
path=$(dirname $dockerfile)
image=$2
tag=latest
docker build -f $dockerfile -t $image $path
echo $DOCKER_ACCESS_TOKEN | docker login -u myhandicappedpet --password-stdin
docker tag $image $image:$tag
docker push $image:$tag
