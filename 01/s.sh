#!/bin/bash
# Script description

if [ -z $(which whois) ]
  then echo "Please, iinstall whois(1): sudo apt-get install whois -y"
  exit
fi

if [ "$EUID" -ne 0 ]
  then echo "Please, run as root"
  exit
fi

remotes=$(netstat -tunapl | awk 'FNR>2{print $5}')
ips=$(echo "$remotes" | cut -d: -f1 | sort | uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+')

for ip in $ips
do
  echo $ip $(whois $ip | awk -F':' '/^Organization/ {print $2}')
done
