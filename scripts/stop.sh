#!/usr/bin/env bash
source ./scripts/init.sh

echo "### Stopping containers ###"
docker-compose -f ${COMPOSE_FILE} stop
