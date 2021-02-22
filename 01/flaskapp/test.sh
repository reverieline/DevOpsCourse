#!/bin/bash

echo
curl -s -XPOST -d '{"word":"test","count":3}' --header "Content-Type: application/json" http://localhost:5000/
echo
