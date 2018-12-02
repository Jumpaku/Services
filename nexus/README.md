# nexus

## Start

```sh
mkdir -p nexus/nexus-data/
sudo chown -R 200:200 nexus/nexus-data/
sudo docker-compose -f nexus/docker-compose.yml up -d
```

## References

- https://stackoverflow.com/questions/48513734/error-while-mounting-host-directory-in-nexus-docker
