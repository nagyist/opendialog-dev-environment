#!/usr/bin/env bash
source ./scripts/init.sh

echo "### Stopping Workspace ###"
docker-compose -f ${COMPOSE_FILE} stop workspace docker-in-docker