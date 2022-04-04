#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${DIR}/..

CHOSEN_DATABASE=$(grep CHOSEN_DATABASE .env | xargs)
CHOSEN_DATABASE=${CHOSEN_DATABASE#*=}

echo "### Starting required containers (db=${CHOSEN_DATABASE})###"
docker-compose up -d php-fpm ${CHOSEN_DATABASE} nginx dgraph-zero dgraph-server redis
