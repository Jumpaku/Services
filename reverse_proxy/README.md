# reverse_proxy

## Prerequisites

```sh
sudo docker network create reverse_proxy_network
```

All serveces proxied are stared.

## Test

### Staging

```sh
export REVERSE_PROXY_STAGE=staging
sudo -E docker-compose up -d
curl -k https://test.jumpaku.net
```

### local

```sh
export REVERSE_PROXY_DOMAINS='test.jumpaku.net -> http://reverse_proxy_test:80'
export REVERSE_PROXY_STAGE='local'
sudo -E docker-compose up -d
curl -k -H 'Host: test.jumpaku.net' https://localhost
```

## Start

```sh
export REVERSE_PROXY_STAGE=production
sudo -E docker-compose up -d
```
