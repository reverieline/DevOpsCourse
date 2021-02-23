#!/bin/bash

err() { cat <<< "$@" 1>&2; }

showhelp() {
  echo "Show most active contributers for giver GitHub repository"
  echo "Usage: $0 <repo>"
  echo "Example: $0 https://github.com/nasa/fprime"
}

if [ -z "$(which jq)" ]; then
  err "Please, install jq package"
  exit 1
fi

if [ $# -ne 1 ]; then
  err "Please, provide valid argument"
  echo
  showhelp
  exit 1
fi

re='(github.com/)(.+)/(.+)'
if [[ $1 =~ $re ]]; then
  USER="${BASH_REMATCH[2]}"
  REPO="${BASH_REMATCH[3]}"
else
  err "Invalid argument"
  echo
  showhelp
  exit 1
fi

DATA=$(curl -sf "https://api.github.com/repos/${USER}/${REPO}/pulls")
if [ $? -ne 0 ]; then
  err "Connection error"
  exit 1
fi

PRS=$(echo "$DATA" | jq -r '.[]| [.state, .user.login ] |@tsv')
PRS=$(echo "$PRS" | awk '$1=="open" {print $1,$2}')

if [ -z "${PRS##*( )}" ]; then
  echo "Nothing  to show"
  exit
fi

PRS=$(echo "$PRS" | sort -k1,2 | uniq -c | sort -r )

echo "Most active contributors for ${USER}/${REPO}"
echo "$(echo "$PRS" | awk 'BEGIN { print "User", "Open_PRs"} { print $3, $1 }' | column -t)"

echo
echo "Labels"
LABELS=$(echo "$DATA" | jq -r '.[]| [ .head.label ] |@tsv')
echo "$(echo "$LABELS" | sort -u)"
