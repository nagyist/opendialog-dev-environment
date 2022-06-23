#!/usr/bin/env bash
source ./scripts/init/sh

echo "### Recreating required containers ###"
docker-compose -f ${COMPOSE_FILE} up --force-recreate -d php-fpm ${CHOSEN_DATABASE} nginx dgraph-zero dgraph-server memcached