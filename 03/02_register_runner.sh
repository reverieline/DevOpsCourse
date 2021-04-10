#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 <gitlab_host> <gitlab_runner_token> <tag,list>"
    exit 1
fi

HOST="$1"
TOKEN="$2"
TAGLIST="$3"

gitlab-runner register -n --url $HOST --registration-token $TOKEN --executor docker --description "Kora Runner" --docker-image "docker:stable" --tag-list $TAGLIST --docker-privileged
