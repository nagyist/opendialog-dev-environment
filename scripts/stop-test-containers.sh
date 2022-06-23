#!/usr/bin/env bash
source ./scripts/init.sh

echo "### Stopping test containers ###"
docker-compose -f ${COMPOSE_FILE} stop dgraph-zero-test dgraph-server-test

bash ${DIR}/stop-workspace.sh