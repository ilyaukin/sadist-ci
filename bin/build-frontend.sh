#!/bin/bash

set -x
docker build -f "Dockerfile-build-frontend" -t "build-frontend" .
docker run -v ./sadist-fe:/sadist-fe build-frontend
mkdir ./sadist-be/app/static
cp -r ./sadist-fe/dist/* ./sadist-be/app/static
