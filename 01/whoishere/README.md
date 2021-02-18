# Whoishere Script
## Description
The script shows information about most popular foreighn connections on the local machine.

## Usage
```sh
sudo ./whoishere.sh [-p process_name_or_pid -s connection_state -n num_lines_to_output  -f field_to_fetch]
```

## Examples
```sh
sudo ./whoishere.sh -p firefox
sudo ./whoishere.sh -f organization
sudo ./whoishere.sh -n 10 -f desc -s estab
```

## Dependencies
You should have `netstat` and `whois` utils installed.
```sh
sudo apt-get install net-tools whois -y
```
