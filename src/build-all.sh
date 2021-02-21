#!/bin/bash

DIR="`dirname \"$0\"`"
PUSH=
PULL=
QUIET=
REG=shkarface/swashbuckle-cli-node-dotnet

usage()
{
    echo "Usage: build-all.sh [options]"
    echo
    echo "Builds all the docker images and optionally pushes them."
    echo
    echo "Options:"
    echo "    -q --quiet        Repository (Default: shkarface/swashbuckle-cli-node-dotnet)"
    echo "    -r --registry     Repository (Default: shkarface/swashbuckle-cli-node-dotnet)"
    echo "    --push            Push the docker images after successful builds"
    echo "    --pull            Pull the docker images before build to minimize build time"
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

while test $# -gt 0
do
    case $1 in
        --push )        shift
                        PUSH=--push
                        ;;
        --pull )        shift
                        PULL=--pull
                        ;;
        -q | --quiet )  shift
                        QUIET=-q
                        ;;
        -r | --registry ) shift
                        REG=$1
                        ;;
        -h | --help )   usage
                        exit 0
                        ;;
    * )                 unknown_option
    esac
    shift
done

"$DIR"/build.sh -r "$REG" --net 3.1 --node 14.x --swashbuckle 5.6.3 "$PUSH" "$PULL" "$QUIET"

"$DIR"/build.sh -r "$REG" --net 3.1 --node 14.x --swashbuckle 6.0.7 "$PUSH" "$PULL" "$QUIET"

"$DIR"/build.sh -r "$REG" --net 5.0 --node 14.x --swashbuckle 6.0.7 "$PUSH" "$PULL" "$QUIET"
