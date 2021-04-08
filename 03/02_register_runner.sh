#!/bin/bash

HOST=https://gitlab.com/
TOKEN=FgftptvtUtRyYULryFT6

gitlab-runner register -n --url $HOST --registration-token $TOKEN --executor docker --description "Deployment Runner" --docker-image "docker:stable" --tag-list deployment --docker-privileged
