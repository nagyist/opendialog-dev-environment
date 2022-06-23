#!/usr/bin/env bash
source ./scripts/init.sh

echo "### Starting ratel container ###"
docker-compose -f ${COMPOSE_FILE} up -d php-fpm ratel
