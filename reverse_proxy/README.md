# reverse_proxy

1. Test Let's Encript in `staging` environment.
1. Replace environment into `production`.

```sh
cat docker-compose-staging.yml \
 | sed 's/# *STAGE *: *.*$/STAGE: production/g' \
 > docker-compose.yml
```
