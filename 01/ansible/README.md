# Ansible playbook to deploy Emoji Flask App
## Notes
Edit inventory.yaml to adapt playboot to your environment.

By default it assumed that target hosts have already ssh keys transfered.
Otherwise, the corresponding variables should be set to enable password authorization:
```yaml
all:
  hosts:
    <remote_host>:
      ansible_connection: ssh
      ansible_user: <remote_userr_name>
      ansible_ssh_pass: <remote_user_pass>
```

Some tasks need raised privileges.
To enable ansible to aquire root priviliges you could either set -K flag to `ansible-playbook` or set sudo password to host variables:
```yaml
all:
  hosts:
    <remote_host>:
      ansible_sudo_pass: <sudo_pass>
```

## Run
```sh
ansible-playbook -K -i inventory.yaml flaskapp.yaml
```
