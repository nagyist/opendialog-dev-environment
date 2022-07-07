#!/usr/bin/env bash
source ./scripts/init.sh

echo "### Starting only the required containers ###"
docker-compose -f ${COMPOSE_FILE} up -d workspace
docker-compose -f ${COMPOSE_FILE} exec workspace bash

bash scripts/stop-workspace.sh
