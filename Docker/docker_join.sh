#!/usr/bin/env bash

BASH_OPTION=bash

REPO_NAME="argnctu/dreamerv3" # Replace with your Docker Hub username and repository name
TAG="gpu" # Change this to the tag you want to use
IMG="${REPO_NAME}:${TAG}"

xhost +
containerid=$(docker ps -aqf "ancestor=${IMG}") && echo $containerid
docker exec -it \
    --privileged \
    -e DISPLAY=${DISPLAY} \
    -e LINES="$(tput lines)" \
    ${containerid} \
    $BASH_OPTION
xhost -