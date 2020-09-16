# reverse_proxy

## Prerequisites

```sh
sudo docker network create reverse_proxy_network
```

## Start reverse proxy

```sh
# sudo -E ./start.sh local < domains.txt
# sudo -E ./start.sh staging < domains.txt
sudo -E docker-compose up -d
```

## Test

### local

```sh
sudo -E docker-compose up -d
curl -k -H 'Host: test.jumpaku.net' https://localhost
```
