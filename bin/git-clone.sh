#!/bin/bash
set -x
if [ -z "$GITHUB_ACCESS_TOKEN" ]; then
  echo "GITHUB_ACCESS_TOKEN must be set" >&2
  exit 1
fi
token=$GITHUB_ACCESS_TOKEN
actor=${GITHUB_ACTOR:-GitHub}
actor_email=${GITHUB_ACTOR_EMAIL:-noreply@github.com}
repo=$1
IFS='/' read -ra A <<< "$repo"
reponame="${A[-1]}"
dirnam=${2:-$reponame}
# make script idempotent:
# keep using the same repo if we checked out it earlier
if [ -d "$dirnam" ]; then
  exit 0
fi
mkdir "$dirnam"
(cd "$dirnam" && \
git clone https://ilyaukin:$token@github.com/$repo.git . && \
git config --local user.name "$actor" && \
git config --local user.email "$actor_email")
