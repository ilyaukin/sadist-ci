#!/bin/bash

set -x
dockerfile=$1
path=$(dirname $dockerfile)
repo=$2
image=$3
tag=${4:-latest}
docker build -f $dockerfile -t $image $path
region=$(echo "$repo" | cut "-d." -f4)
host=$(echo "$repo" | cut "-d/" -f1)
aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin $host
docker tag $image $repo:$tag
docker push $repo:$tag
