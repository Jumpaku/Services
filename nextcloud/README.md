# nextcloud

## note

* Set MYSQL_ROOT_PASSWORD and MYSQL_PASSWORD.

```sh
cat docker-compose-template.yml \
 | sed 's/MYSQL_ROOT_PASSWORD=.*$/MYSQL_ROOT_PASSWORD=<root password>/g' \
 | sed 's/MYSQL_PASSWORD=.*$/MYSQL_PASSWORD=<admin password>/g' \
 > docker-compose.yml
```
