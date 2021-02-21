#!/bin/bash

for i in $@; do :; done

DIR="`dirname \"$0\"`"
REG=shkarface/swashbuckle-cli-node-dotnet
PUSH=0
PULL=0
QUIET=
NET_VERSION=3.1
NODE_VERSION=14.x
SWASHBUCKLE_VERSION=5.6.3

usage()
{
    echo "Usage: build-docker.sh [options]"
    echo
    echo "Builds the docker image and optionally pushes it."
    echo
    echo "Options:"
    echo "    -r --registry     Repository (Default: shkarface/swashbuckle-cli-node-dotnet)"
    echo "    -q --quiet        Suppress the build output and print image ID on success"
    echo "    --net             .NET SDK version (Default: 3.1)"
    echo "    --node            NodeJS version (Default: 14.x)"
    echo "    --pull            Pull the docker image before build to minimize build time"
    echo "    --push            Push the docker image after successful build"
    echo "    --swashbuckle     Swashbuckle version (Default: 5.6.3)"
}

unknown_option()
{
    if [ ! -z "$1" ]; then
        echo "Invalid option $1"
        echo
        usage
        exit -1
    fi
}

pull()
{
    if [ $PULL = 1 ]; then
        docker pull $QUIET "$IMAGE"
    elif [ -z $QUIET ]; then
         echo "Image with variation $TAG not found"
    fi
}

build()
{
    docker build $QUIET -t "$IMAGE" \
        --build-arg NET_VERSION="$NET_VERSION" \
        --build-arg SWASHBUCKLE_VERSION="$SWASHBUCKLE_VERSION" \
        --build-arg NODE_VERSION="$NODE_VERSION" "$DIR" || { echo "Could not build docker image!"; exit; }
}

push()
{
    if [ $PUSH = 1 ]; then
        docker push "$IMAGE"
    fi
}

while test $# -gt 0
do
    case $1 in
        --net )         shift
            NET_VERSION=$1
                        ;;
        --node )         shift
            NODE_VERSION=$1
                        ;;
        --push )        shift
                        PUSH=1
                        ;;
        --pull )        shift
                        PULL=1
                        ;;
        -q | --quiet )  shift
                        QUIET=-q
                        ;;
        -r | --registry ) shift
                        REG=$1
                        ;;
        --swashbuckle ) shift
            SWASHBUCKLE_VERSION=$1
                        ;;
        -h | --help )   usage
                        exit 0
                        ;;
    * )                 unknown_option
    esac
    shift
done

[ -z "$NET_VERSION" ] && { echo ".NET version not set"; exit -3;  }
[ -z "$NODE_VERSION" ] && { echo "Node version not set"; exit -3;  }
[ -z "$SWASHBUCKLE_VERSION" ] && { echo "Swashbuckle version not set"; exit -3;  }

if [ -z $QUIET ]; then
    echo "Using versions:"
    echo -e "    node:        v$NODE_VERSION"
    echo -e "    dotnet:      v$NET_VERSION"
    echo -e "    swashbuckle: v$SWASHBUCKLE_VERSION"
    echo
fi

TAG="$SWASHBUCKLE_VERSION"-net"$NET_VERSION"-node"$NODE_VERSION"
IMAGE="$REG":"$TAG"

pull
build && \
push
