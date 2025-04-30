#!/usr/bin/env bash

REPOSITORY="argnctu/dreamerv3" # Replace with your Docker Hub username and repository name
TAG="gpu" # Replace with the tag you want to use. Make sure to be the same as that in docker_run.sh
IMG="${REPOSITORY}:${TAG}"

# Push the image to Docker Hub
docker login
docker push ${IMG}