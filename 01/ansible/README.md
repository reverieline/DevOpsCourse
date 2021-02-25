# Ansible playbook to deploy Emoji Flask App
## Run
Edit inventory.yaml to adapt playboot to your environment.
By default it assumed that target hosts have already ssh key transfered.
To override this behavior, the next host variables should be set:
```yaml
all:
  hosts:
    <remote_host>:
      ansible_connection: ssh
      ansible_user: <remote_userr_name>
      ansible_ssh_pass: <remote_user_pass>
```

Some tasks need raised privileges.
To enable ansible to aquire root priviliges you couuld either set -K flag to ansible-playbook or set sudo password to host variables:
```yaml
all:
  hosts:
    <remote_host>:
      ansible_sudo_pass: <sudo_pass>
```

