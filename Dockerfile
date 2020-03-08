FROM golang:1.13.5-alpine

LABEL "com.github.actions.name"="Go Release Binary"
LABEL "com.github.actions.description"="Automate publishing Go build artifacts for GitHub releases"
LABEL "com.github.actions.icon"="cpu"
LABEL "com.github.actions.color"="orange"

LABEL "name"="Automate publishing Go build artifacts for GitHub releases through GitHub Actions"
LABEL "version"="1.0.1"
LABEL "repository"="http://github.com/tpretz/go-release.action"
LABEL "homepage"="http://github.com/tpretz/go-release.action"

LABEL "maintainer"="Thomas Pressnell <tom@pressnell.uk>"

RUN apk add --no-cache curl jq git build-base

ADD entrypoint.sh /entrypoint.sh
ADD build.sh /build.sh
ENTRYPOINT ["/entrypoint.sh"]
