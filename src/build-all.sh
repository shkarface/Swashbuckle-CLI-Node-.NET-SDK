#!/bin/bash

DIR="`dirname \"$0\"`"
PUSH=
REG=shkarface/swashbuckle-cli-node-dotnet

usage()
{
    echo "Usage: build-all.sh [options]"
    echo
    echo "Builds all the docker images and optionally pushes them."
    echo
    echo "Options:"
    echo "    -r --registry     Repository (Default: shkarface/swashbuckle-cli-node-dotnet)"
    echo "    --push            Push the docker image after successful build"
    exit -1
}

while test $# -gt 0
do
    case $1 in
        --push )        shift
                        PUSH=--push
                        ;;
        -r | --registry ) shift
                        REG=$1
                        ;;
        -h | --help )   usage
                        exit
                        ;;
    esac
    shift
done

"$DIR"/build.sh -r "$REG" --net 3.1 --node 14.x --swashbuckle 5.6.3 "$PUSH"
echo

"$DIR"/build.sh -r "$REG" --net 3.1 --node 14.x --swashbuckle 6.0.7 "$PUSH"
echo

"$DIR"/build.sh -r "$REG" --net 5.0 --node 14.x --swashbuckle 6.0.7 "$PUSH"
