#!/bin/bash

docker-compose exec --user git gitea /init-data/initialize.sh
docker-compose up -d
