# Transform script
Original notation:
```sh
jq -r '.prices[][]' quotes.json | grep -oP '\d+\.\d+' | tail -n 14 | awk -v mean=0 '{mean+=$1} END {print mean/14}'
```
Equivalent notation without regexp:
```sh
jq -r '.prices[]|@tsv' quotes.json | tail -n 14 | awk -v mean=0 '{mean+=$2} END {print mean/14}'
````

# volatility.sh 
The script shows volatility values for specific month in years range
```sh
./volatility.sh quotes.json 03 2015 2020
```
