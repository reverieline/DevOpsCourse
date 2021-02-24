#!/bin/bash

ansible-playbook -k -i inventory.yaml --vault-id dev@vpass flaskapp.yaml
