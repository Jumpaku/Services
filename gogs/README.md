# gogs

## Start

```sh
export GOGS_POSTGRES_PASSWORD=gogs_postgres_password
sudo -E docker-compose -f gogs/docker-compose.yml up -d
```

## Configure

Edit `gogs/data/gogs/conf/app.ini`.
