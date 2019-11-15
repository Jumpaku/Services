# ldap

## Prerequisite

```sh
export LDAP_ROOT_PW=secret_password
sudo -E docker network create ldap_network
```

## Start

```sh
sudo -E ./start.sh
```

## Initialize

```sh
sudo -E ./initialize.sh
```

## Client Commands

### init

```sh
sudo -E docker-compose run ldap-client init
```

### display

```
sudo -E docker-compose run ldap-client display
```

### modify

```sh
sudo -E docker-compose run ldap-client modify < users.ldif
```

### hash

```sh
echo -n "app_password" | sudo -E docker-compose run ldap-client hash
```

### ash

```sh
sudo docker-compose run ldap-client ash
```

## Test

### Users

```sh
sudo -E docker-compose -f run ldap-client display
``` 

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
```
