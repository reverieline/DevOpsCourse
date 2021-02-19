#!/bin/bash

# Output to stderr

err() { cat <<< "$@" 1>&2; }


# Load parameters

NUMLINES=5
PROCESS=""
STATE=""
FIELD="organization"
while [ $# -gt 0 ]; do
  key="$1"
  case $key in
    -h|--help)
    echo "Usage: sudo $0 -p process_name_or_pid -n num_lines_to_output -s connection_state -f field_to_fetch"
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
    -f|--field)
    FIELD="$2"
    shift
    shift
    ;;
  esac
done


# Check environment

if [ -z "$(which netstat)" ]; then
  err "Please install net-tools package."
  exit 1
fi

if [ -z "$(which whois)" ]; then
  err "Please iinstall whois package."
  exit 1
fi

if [ "$EUID" -ne 0 ]; then
  echo "Run as root to see more details"
fi


# Check parameters

if [ ! -z "$PROCESS" ]; then
  re='^[0-9]+$'
  if [[ "$PROCESS" =~ $re ]]; then
     PROCESS="[^0-9]${PROCESS}/"
  else
    PROCESS="/$PROCESS"
  fi
fi

if [ ! -z "$STATE" ]; then
  STATE=$(echo "$STATE" | tr a-z A-Z)
fi

re='^[0-9]+$'
if [[  ! "$NUMLINES" =~ $re ]]; then
  err "-n shoud be natural number"
  exit 1
fi


# Fetch data

REMOTES="$(netstat -tunapl |
	awk '$6~/^[^0-9]/ && $5~/^[1-9]/ {
		print $5, $6, $7}' |
	column -t)"
REMOTES=$(echo "$REMOTES" | grep "$PROCESS")
REMOTES=$(echo "$REMOTES" | grep "$STATE")

if [ -z  "$REMOTES" ];then
  exit;
fi

echo "CONNECTIONS:"
echo "$REMOTES"

IPS=$(echo "$REMOTES" | cut -d: -f1 | sort | uniq -c | sort)
IPS=$(echo "$IPS" | tail -n "$NUMLINES" | grep -oP '(\d+\.){3}\d+')

echo $'\nWHOIS:'
for ip in $IPS
do
  echo $ip $'\t' $(whois $ip | grep  -i "^$FIELD")
done
