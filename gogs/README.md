# gogs

## note

Set POSTGRES_USER and POSTGRES_PASSWORD.

```sh
cat docker-compose-template.yml \
 | sed 's/"POSTGRES_USER=.*".*$/"POSTGRES_USER=<user id>"/g' \
 | sed 's/"POSTGRES_PASSWORD=.*".*$/"POSTGRES_PASSWORD=<password>"/g' \
 > docker-compose.yml
```