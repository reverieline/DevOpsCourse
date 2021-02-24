#!/bin/bash

ansible all -i inventory.yaml --vault-id dev@vpass -m 'ansible.builtin.ping'
