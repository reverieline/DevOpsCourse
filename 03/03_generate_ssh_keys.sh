#!/bin/bash

ssh-keygen -b 2048
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
echo
echo
echo Private key for GitLab environment
cat ~/.ssh/id_rsa
echo
echo