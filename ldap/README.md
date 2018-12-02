# ldap

## Prerequisite

```sh
sudo docker network create ldap_network
```

## Start

```sh
export LDAP_ROOT_PW=secret_password
sudo -E docker-compose -f ./ldap/docker-compose.yml up --build -d
```

## Configure

### slapd

Edit `openldap/slapd.conf`, rebuild, and restart.

### Users

Edit `ldap_init/data/users.ldif`.

```sh
sudo -E docker-compose run ldap_init ash
```

```sh
ldapadd -x -h openldap -D "cn=admin,dc=jumpaku,dc=net" -w secret_password -f users.ldif
ldappasswd -x -h openldap -D "cn=admin,dc=jumpaku,dc=net" -w secret_password -s user_password "uid=jumpaku,ou=users,dc=jumpaku,dc=net"
```

## Test

```sh
sudo -E docker-compose -f ./ldap/docker-compose.yml run ldap_init ash
```

```sh
ldapsearch -x -h openldap -D "cn=admin,dc=jumpaku,dc=net" -w secret_password -b "dc=jumpaku,dc=net" "(objectClass=*)"
```
