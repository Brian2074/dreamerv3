#!/usr/bin/env bash

REPO_NAME="argnctu/dreamerv3"
TAG="gpu"
IMG="${REPO_NAME}:${TAG}"

docker pull ${IMG}