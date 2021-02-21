#!/bin/bash

for i in $@; do :; done

DIR="`dirname \"$0\"`"
REG=shkarface/swashbuckle-cli-node-dotnet
PUSH=0
NET_VERSION=3.1
NODE_VERSION=14.x
SWASHBUCKLE_VERSION=5.6.3

echo $DIR

usage()
{
    echo "Usage: build-docker.sh [options]"
    echo
    echo "Builds the docker image and optionally pushes it."
    echo
    echo "Options:"
    echo "    -r --registry     Repository (Default: shkarface/swashbuckle-cli-node-dotnet)"
    echo "    --net             .NET SDK version (Default: 3.1)"
    echo "    --node            NodeJS version (Default: 14.x)"
    echo "    --push            Push the docker image after successful build"
    echo "    --swashbuckle     Swashbuckle version (Default: 5.6.3)"
    exit -1
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
        -r | --registry ) shift
            REG=$1
                        ;;
        --swashbuckle ) shift
            SWASHBUCKLE_VERSION=$1
                        ;;
        -h | --help )   usage
                        exit
                        ;;
    esac
    shift
done

[ -z "$NET_VERSION" ] && { echo ".NET version not set"; exit -3;  }
[ -z "$NODE_VERSION" ] && { echo "Node version not set"; exit -3;  }
[ -z "$SWASHBUCKLE_VERSION" ] && { echo "Swashbuckle version not set"; exit -3;  }

echo "Using versions:"
echo -e "    node:        v$NODE_VERSION"
echo -e "    dotnet:      v$NET_VERSION"
echo -e "    swashbuckle: v$SWASHBUCKLE_VERSION"
echo

TAG=v"$SWASHBUCKLE_VERSION"-net"$NET_VERSION"
IMAGE="$REG":"$TAG"

docker build -t "$IMAGE" \
    --build-arg NET_VERSION="$NET_VERSION" \
    --build-arg SWASHBUCKLE_VERSION="$SWASHBUCKLE_VERSION" \
    --build-arg NODE_VERSION="$NODE_VERSION" "$DIR" || { echo "Could not build docker image!"; exit; }

[ $PUSH = 1 ] && { docker push "$IMAGE"; }
