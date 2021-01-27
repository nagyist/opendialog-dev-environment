#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${DIR}/..

echo "### Starting test containers ###"
docker-compose up -d dgraph-zero-test dgraph-server-test

bash ${DIR}/start-workspace.sh
