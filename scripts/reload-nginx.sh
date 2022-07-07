#!/usr/bin/env bash
source ./scripts/init.sh

echo "### Reloading NGINX ###"
docker-compose -f ${COMPOSE_FILE}  up -d nginx
docker-compose -f ${COMPOSE_FILE}  exec nginx nginx -s reload
