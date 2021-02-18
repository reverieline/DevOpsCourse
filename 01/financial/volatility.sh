#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Show volatility per year for given month"
  echo "Example: $0 quotes.json 03 2015 2020"
  exit
fi

PAIRS=$(jq -r '.prices[]|@tsv' $1)

# num days in month
dim(){
  echo $(cal $1 $2 | awk 'NF {DAYS = $NF}; END {print DAYS}')
}

# volatility function
# $1 - from date
# $2 - to date
vol() {
  local pairs="$(echo "$PAIRS" | awk "\$1>$(date --date=$1 +%s)000 && \$1<$(date --date=$2 +%s)000 {print}")"
  local v=$(echo "$pairs" | awk 'NR==1 {min=$2} $2<min {min=$2} NR==1 {max=$2} max<$2 {max=$2} END { print (max-min)/2, "(records: " NR}')
  echo $v
}

for y in $(seq $3 $4); do
  echo $2 $y - $(vol "$y-$2-01T00:00:00" "$y-$2-$(dim $2 $y)T23:59:59")
done


