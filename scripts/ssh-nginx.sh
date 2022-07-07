#!/usr/bin/env bash
source ./scripts/init.sh

echo "### SSH to nginx ###"
docker-compose -f ${COMPOSE_FILE} up -d nginx
docker-compose -f ${COMPOSE_FILE} exec nginx bash
