#!/bin/bash
# Script description

POSITIONAL=()
NUMLINES=5
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -h|--help)
    echo "Usage: sudo $0 -p process_name_or_pid -n num_lines_to_output -s connection_state"
    exit
    ;;
    -p|--process)
    PROCESS="$2"
    shift
    shift
    ;;
    -n|--num-lines)
    NUMLINES="$2"
    shift
    shift
    ;;
    -s|--state)
    STATE="$2"
    shift
    shift
    ;;
    *)
    POSITIONAL+=("$1")
    shift
    ;;
  esac
done
set -- "${POSITIONAL[@]}"

if [ -z $(which netstat) ]; then
  echo "Please, install net-tools package"
  exit
fi

if [ -z $(which whois) ]
  then echo "Please, iinstall whois(1): sudo apt-get install whois -y"
  exit
fi

if [ "$EUID" -ne 0 ]
  then echo "Please, run as root"
  exit
fi

REMOTES="$(netstat -tunapl | awk 'NR>2 && $6~/^[^0-9]/  {print $5, $6, $7}' | column -t)"

if [ ! -z $PROCESS ]; then
  re='^[0-9]+$'
  if [[ $PROCESS =~ $re ]]; then
    PROCESS="[^0-9]${PROCESS}/"
  fi
  REMOTES=$(echo "$REMOTES" | grep $PROCESS)
fi

if [ ! -z $STATE ]; then
  REMOTES=$(echo "$REMOTES" | grep $STATE)
fi

if [ -z $REMOTES ]; then exit; fi

echo "CONNECTIONS:"
echo "$REMOTES"

echo $'\nWHOIS:'

IPS=$(echo "$REMOTES" | cut -d: -f1 | sort | uniq -c | sort | tail -n "$NUMLINES" | grep -oP '(\d+\.){3}\d+')

for ip in $IPS
do
  echo $ip $'\t' $(whois $ip | awk -F':' '/^Organization/ {print $2}')
done
