# ldap

## Prerequisite

```sh
export LDAP_ROOT_DN_PW=secret_password
sudo -E docker network create ldap_network
```

## Start

```sh
sudo -E docker-compose up -d
```

## Initialize

```sh
sudo -E docker-compose exec openldap slapadd < users.ldif
```

## Test

### Users

```sh
sudo -E docker-compose exec openldap slapcat
``` 

<!--
### Accesses (ldapsearch)

```sh
sudo -E docker-compose run ldap-client ash

# Valid accesses.
# As app
ldapsearch -LLL -x -h openldap -D "cn=app,dc=jumpaku,dc=net" -w app_password -b "uid=testuser,ou=users,dc=jumpaku,dc=net" "(objectClass=*)"
# As self
ldapsearch -LLL -x -h openldap -D "uid=testuser,ou=users,dc=jumpaku,dc=net" -w user_password -b "uid=testuser,ou=users,dc=jumpaku,dc=net" "(objectClass=*)"

# Invalid accesses.
# As others
ldapsearch -LLL -x -h openldap -D "uid=testuser,ou=users,dc=jumpaku,dc=net" -w user_password -b "uid=jumpaku,ou=users,dc=jumpaku,dc=net" "(objectClass=*)"
# As anonymous
ldapsearch -LLL -x -h openldap -b "dc=jumpaku,dc=net" "(objectClass=*)"

# TLS
ldapsearch -LLL -x -h ldaps.jumpaku.net -p 636 -Z -D "cn=app,dc=jumpaku,dc=net" -w app_password -b "uid=testuser,ou=users,dc=jumpaku,dc=net" "(objectClass=*)"
```
-->
