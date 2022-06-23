#!/usr/bin/env bash
source ./scripts/init.sh

echo "### Starting Workspace ###"
docker-compose -f ${COMPOSE_FILE} up -d workspace
