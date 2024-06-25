#!/bin/bash
set -x
dirname=$1
frombranch=$2
tobranch=$3
(cd dirname && \
git checkout $tobranch && \
git fetch origin $frombranch:$frombranch && \
git merge $frombranch -m "Merge $frombranch to $tobranch" && \
git push origin $tobranch)
