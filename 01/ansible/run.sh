#!/bin/bash

ansible-playbook -kK -i inventory.yaml --vault-id dev@vpass flaskapp.yaml
