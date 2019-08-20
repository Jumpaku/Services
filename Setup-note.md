# Ubuntu

## Update OS

## Users

1. `sudo adduser user_name`
2. `sudo gpasswd -a user_name sudo`

## iptables

1. Change /etc/iptables/iptables.rules
2. `sudo reboot`

```sh
cp ./iptables.rules /etc/iptables/iptables.rules
sudo iptables-restore -n < /etc/iptables/iptables.rules
```

## ssh

1. Generate keys

2. Change /etc/ssh/sshd_config

* Port 22 -> Port **** 
* PermitRootLogin yes -> PermitRootLogin no 
* PasswordAuthentication yes -> PasswordAuthentication no

3. Restart ssh  
`sudo /etc/init.d/ssh restart`

## docker

install docker and docker-compose

## Reverse proxy with Let's Encript

use steveltn/https-portal

## nexus3

note: `chown -R 200:200 path/to/directory/of/nexus-data/` .
https://stackoverflow.com/questions/48513734/error-while-mounting-host-directory-in-nexus-docker

## nextcloud, gogs

### reverse_proxy/docker-compose.yml

```yml
  environment:
    - "CLIENT_MAX_BODY_SIZE=512M"
```

### gogs/app.ini

```ini
[repository.upload]
; Maximum size of each file in MB
FILE_MAX_SIZE = 512
; Maximum number of files per upload
MAX_FILES = 1000
```

### nextcloud

Disable Versions app from admin panel.