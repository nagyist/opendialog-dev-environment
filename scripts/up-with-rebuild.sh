#!/usr/bin/env bash
echo "### Recreating required containers ###"
docker-compose up --force-recreate -d php-fpm mysql nginx dgraph-zero dgraph-server memcached