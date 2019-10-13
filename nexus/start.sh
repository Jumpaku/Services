#!/bin/sh

mkdir -p nexus-data/
chmod 775 nexus-data/
mkdir -p nexus-backup/
chmod 775 nexus-backup/
docker-compose up -d
