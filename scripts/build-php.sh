#!/usr/bin/env bash
source ./scripts/init.sh

echo "### Rebuilding containers that use PHP ###"
docker-compose -f ${COMPOSE_FILE} build workspace php-fpm
