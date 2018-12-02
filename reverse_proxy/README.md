# reverse_proxy

## Prerequisites

```sh
sudo docker network create reverse_proxy_network
```

All serveces proxied are stared.

## Test

### Staging

```sh
cd reverse_proxy
export REVERSE_PROXY_STAGE=staging
sudo -E docker-compose up -d
curl -k https://test.jumpaku.net
```

### local

```sh
cd reverse_proxy
export REVERSE_PROXY_DOMAINS='test.jumpaku.net -> http://reverse_proxy_test:80'
export REVERSE_PROXY_STAGE='local'
sudo -E docker-compose up -d
curl -k -H 'Host: test.jumpaku.net' https://localhost
```

## Start

```sh
cd reverse_proxy
export REVERSE_PROXY_STAGE=production
sudo -E docker-compose up -d
```

## References

* https://github.com/docker/compose/issues/4223
