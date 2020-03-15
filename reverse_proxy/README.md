# reverse_proxy

## Prerequisites

```sh
sudo docker network create reverse_proxy_network
```

All serveces proxied are stared.

## Only prepare certs

```sh
# sudo -E ./start.sh certs local < domains.txt
# sudo -E ./start.sh certs staging < domains.txt
sudo -E ./start.sh certs production < domains.txt
```

## Start reverse proxy

```sh
# sudo -E ./start.sh local < domains.txt
# sudo -E ./start.sh staging < domains.txt
sudo -E ./start.sh production < domains.txt
```

## Test

### local

```sh
sudo -E docker-compose up -d
curl -k -H 'Host: test.jumpaku.net' https://localhost
```

### Staging

```sh
sudo -E docker-compose up -d
curl -k https://test.jumpaku.net
```

## References

* https://github.com/docker/compose/issues/4223
