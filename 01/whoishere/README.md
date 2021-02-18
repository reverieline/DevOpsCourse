# Whoishere Script
## Description
The script shows organizations of most popular remote connections opened on local machine.

## Usage
```sh
sudo ./whoishere [-p process_name_or_pid -s connection_state -n num_lines_to_output]
```

## Dependencies
You should have `netstat` and `whois` utils installed.
```sh
sudo apt-get install net-tools whois -y
```
