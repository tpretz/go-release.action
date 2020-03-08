#!/bin/bash

set -eu

EVENT_DATA=$(cat $GITHUB_EVENT_PATH)
#echo $EVENT_DATA | jq .
PROJECT_ROOT="/home/github.com/${GITHUB_REPOSITORY}"
PROJECT_NAME=$(basename $GITHUB_REPOSITORY)
RELEASE_NAME=$(echo $EVENT_DATA | jq -r .release.tag_name)
NAME="${PROJECT_NAME}_${RELEASE_NAME}_${GOOS}_${GOARCH}"

EXT=''

if [ $GOOS == 'windows' ]; then
  EXT='.exe'
fi

mkdir -p $PROJECT_ROOT
rmdir $PROJECT_ROOT
ln -s $GITHUB_WORKSPACE $PROJECT_ROOT
cd $PROJECT_ROOT

GO111MODULE="on"
CGO_ENABLED=0

go build -o ${NAME}${EXT} -ldflags="-X main.Version=${RELEASE_NAME} -s -w"
chmod +x ${NAME}${EXT}
