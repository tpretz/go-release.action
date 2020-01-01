#!/bin/sh

set -eux

/build.sh

EVENT_DATA=$(cat $GITHUB_EVENT_PATH)
echo $EVENT_DATA | jq .
UPLOAD_URL=$(echo $EVENT_DATA | jq -r .release.upload_url)
UPLOAD_URL=${UPLOAD_URL/\{?name,label\}/}
RELEASE_NAME=$(echo $EVENT_DATA | jq -r .release.tag_name)
PROJECT_NAME=$(basename $GITHUB_REPOSITORY)
NAME="${PROJECT_NAME}_${RELEASE_NAME}_${GOOS}_${GOARCH}"

EXT=''

if [ $GOOS == 'windows' ]; then
  EXT='.exe'
fi

# tar cvfz tmp.tgz "${PROJECT_NAME}${EXT}"
CHECKSUM=$(md5sum ${PROJECT_NAME}-${VERSION}-${GOOS}-${GOARCH}${EXT} | cut -d ' ' -f 1)

curl \
  -X POST \
  --data-binary @${PROJECT_NAME}-${VERSION}-${GOOS}-${GOARCH}${EXT} \
  -H 'Content-Type: application/binary' \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  "${UPLOAD_URL}?name=${PROJECT_NAME}-${VERSION}-${GOOS}-${GOARCH}${EXT}"

curl \
  -X POST \
  --data $CHECKSUM \
  -H 'Content-Type: text/plain' \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  "${UPLOAD_URL}?name=${NAME}_checksum.txt"
