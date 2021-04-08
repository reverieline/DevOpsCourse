#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <gitlab_host> <gitlab_runner_token>"
    exit 1
fi

HOST="$1"
TOKEN="$2"

gitlab-runner register -n --url $HOST --registration-token $TOKEN --executor docker --description "Deployment Runner" --docker-image "docker:stable" --tag-list deployment --docker-privileged
