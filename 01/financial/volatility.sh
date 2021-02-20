#!/bin/bash

err() { cat <<< "$@" 1>&2; }

showhelp() {
  echo "Month by month volatility"
  echo "Usage: $0 <--quotes-path|-q quotes_file.json> [--start-year|-s YYYY_start --end-year|-e YYYY_end]"
  echo "Example: $0 -q quotes.json -s 2015 -e 2017"
  exit
}

if [ $# -eq 0 ]; then
  showhelp
  exit
fi


# Fetch parameters

QUOTESPATH=""
STARTYEAR=""
ENDYEAR=""
while [ $# -gt 0 ]; do
  key="$1"
  case $key in
    -h|--help)
    showhelp
    ;;
    -q|--quotes-path)
    QUOTESPATH="$2"
    shift
    shift
    ;;
    -s|--start-year)
    STARTYEAR="$2"
    shift
    shift
    ;;
    -e|--end-year)
    ENDYEAR="$2"
    shift
    shift
    ;;
    *)
    echo "$1 - unregognized parameter"
    shift
    ;;
  esac
done


# Check parametesr

if [ -z "$QUOTESPATH" ]; then
  err "--quotes-path parameter is required"
  exit 1
fi


# Fetch data

PAIRS=$(jq -r '.prices[]|@tsv' $QUOTESPATH)
if [ $? -ne 0 ]; then exit 1; fi


# num days in month
# $1 - month (03)
# $2 - year (2015)

dim(){
  echo $(cal $1 $2 | awk 'NF {DAYS = $NF}; END {print DAYS}')
}


# volatility function
# $1 - from date (1623124564)
# $2 - to date (1638727382)

vol() {
  local pairs="$(echo "$PAIRS" | awk "\$1>$(date --date=$1 +%s)000 && \$1<$(date --date=$2 +%s)000 {print}")"
  local v=$(echo "$pairs" | awk 'NR==1 {min=$2} $2<min {min=$2} NR==1 {max=$2} max<$2 {max=$2} END { print ((max-min)/2)":"NR}')
  echo $v
}

# Determine start and end dates
FIRSTLASTDATE=$(echo "$PAIRS" | awk 'NR==1 { first=$1 } NR { last=$1 } END { print first":"last }')

FIRSTDATE=$(echo $FIRSTLASTDATE | cut -d: -f1)
FIRSTDATE=${FIRSTDATE::-3}
FIRSTDATE=$(date -d "@$FIRSTDATE" +%Y-%m-%d)

LASTDATE=$(echo $FIRSTLASTDATE | cut -d: -f2)
LASTDATE=${LASTDATE::-3}
LASTDATE=$(date -d "@$LASTDATE" +%Y-%m-%d)

if [ -z "$STARTYEAR" ]; then STARTYEAR=$(date -d "$FIRSTDATE" +%Y); fi
if [ -z "$ENDYEAR" ]; then ENDYEAR=$(date -d "$LASTDATE" +%Y); fi


# Output volatility per month for given period

printf "YEAR\tJen\tFeb\tMar\tApr\tMay\tJun\tJul\tAug\tSep\tOct\tNov\tDec\n"

for y in $(seq $STARTYEAR $ENDYEAR); do
  printf "$y\t"

  for m in $(seq 1 12); do
    vr=$(vol "$y-$m-01T00:00:00" "$y-$m-$(dim $m $y)T23:59:59")
    v=$(echo "$vr" | cut -d: -f1)
    r=$(echo "$vr" | cut -d: -f2)

    if [ $r -gt 1 ]; then
      printf $v
    else
      printf ""
    fi

    if [ $m -ne 12 ]; then printf "\t"; else printf "\n"; fi
  done

done

