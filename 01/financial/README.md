# Transform script
* original notation:
```sh
jq -r '.prices[][]' quotes.json | grep -oP '\d+\.\d+' | tail -n 14 | awk -v mean=0 '{mean+=$1} END {print mean/14}'
```
* equivalent notation without regexp
```sh
jq -r '.prices[]|@tsv' quotes.json | tail -n 14 | awk -v mean=0 '{mean+=$2} END {print mean/14}'
````