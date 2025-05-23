#!/usr/bin/env bash

ARGS=("$@")
REPO_NAME="argnctu/dreamerv3" # Replace with your Docker Hub username and repository name
TAG="gpu" # Change this to the tag you want to use
IMG="${REPO_NAME}:${TAG}"
PROJ_NAME="dreamerv3"

# Make sure processes in the container can connect to the x server
# Necessary so gazebo can create a context for OpenGL rendering (even headless)
XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]; then
    xauth_list=$(xauth nlist $DISPLAY)
    xauth_list=$(sed -e 's/^..../ffff/' <<<"$xauth_list")
    if [ ! -z "$xauth_list" ]; then
        echo "$xauth_list" | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

# Prevent executing "docker run" when xauth failed.
if [ ! -f $XAUTH ]; then
    echo "[$XAUTH] was not properly created. Exiting..."
    exit 1
fi

xhost +
docker run \
    -it \
    --rm \
    -e DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -e XAUTHORITY=$XAUTH \
    -v "$XAUTH:$XAUTH" \
    -v "/home/$USER/$PROJ_NAME:/home/arg/$PROJ_NAME" \
    -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -v "/etc/localtime:/etc/localtime:ro" \
    -v "/dev:/dev" \
    -v "/var/run/docker.sock:/var/run/docker.sock" \
    -w "/home/arg/$PROJ_NAME" \
    --user "root:root" \
    --network host \
    --privileged \
    --security-opt seccomp=unconfined \
    --gpus all \
    ${IMG} \
    bash
xhost -