#!/usr/bin/env bash
source ./scripts/init.sh

echo "### Starting test containers ###"
docker-compose -f ${COMPOSE_FILE} up -d dgraph-zero-test dgraph-server-test

bash ${DIR}/start-workspace.sh
