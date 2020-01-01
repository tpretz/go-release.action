#!/bin/sh

set -eux

PROJECT_ROOT="/go/src/github.com/${GITHUB_REPOSITORY}"
PROJECT_NAME=$(basename $GITHUB_REPOSITORY)

EXT=''

if [ $GOOS == 'windows' ]; then
  EXT='.exe'
fi

mkdir -p $PROJECT_ROOT
rmdir $PROJECT_ROOT
ln -s $GITHUB_WORKSPACE $PROJECT_ROOT
cd $PROJECT_ROOT
go get -v ./...
go build -o ${PROJECT_NAME}-${VERSION}-${GOOS}-${GOARCH}${EXT} -ldflags="-X main.Version=${VERSION} -s -w"
