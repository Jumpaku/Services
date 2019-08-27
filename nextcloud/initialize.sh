#!/bin/bash

docker-compose exec --user www-data nextcloud /init-data/init.sh
docker-compose up -d
