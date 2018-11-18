# nextcloud

## note

* Set POSTGRESMYSQL_ROOT_PASSWORD_USER and MYSQL_PASSWORD.

```sh
cat docker-compose-template.yml \
 | sed 's/MYSQL_ROOT_PASSWORD=.*$/MYSQL_ROOT_PASSWORD=<root password>/g' \
 | sed 's/MYSQL_PASSWORD=.*$/MYSQL_PASSWORD=<admin password>/g' \
 > docker-compose.yml
```
