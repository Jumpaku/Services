# gogs

## Start

```sh
export GOGS_POSTGRES_PASSWORD=gogs_postgres_password
sudo -E docker-compose -f gogs/docker-compose.yml up -d
sudo cp gogs/app.ini gogs/gogs/data/gogs/conf/
```

## Configure

Edit `gogs/data/gogs/conf/app.ini`.
