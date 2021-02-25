#!/bin/bash

ansible-playbook -K -i inventory.yaml --vault-id dev@vpass flaskapp.yaml
