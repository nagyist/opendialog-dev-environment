#!/usr/bin/env bash
source ./scripts/init.sh

echo "### Starting required containers (db=${CHOSEN_DATABASE})###"
docker-compose -f ${COMPOSE_FILE} up -d php-fpm ${CHOSEN_DATABASE} nginx dgraph-zero dgraph-server redis
