#!/bin/bash

ansible all -i inventory.yaml --vault-id dev@vpass -m 'ansible.builtin.ping'

ansible-playbook -i inventory.yaml --vault-id dev@vpass flaskapp.yaml
