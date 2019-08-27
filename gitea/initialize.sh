#!/bin/bash

docker-compose exec --user git gitea /init-data/init.sh
docker-compose up -d
