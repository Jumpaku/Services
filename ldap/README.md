# ldap

## note

* Set LDAP_ADMIN_PASSWORD.

```sh
cat docker-compose-template.yml \
 | sed 's/"LDAP_ADMIN_PASSWORD=.*".*$/"LDAP_ADMIN_PASSWORD=<ldap admin password>"/g' \
 > docker-compose.yml
```
