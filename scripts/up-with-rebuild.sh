#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${DIR}/..

CHOSEN_DATABASE=$(grep CHOSEN_DATABASE .env | xargs)
CHOSEN_DATABASE=${CHOSEN_DATABASE#*=}

echo "### Recreating required containers ###"
docker-compose up --force-recreate -d php-fpm ${CHOSEN_DATABASE} nginx dgraph-zero dgraph-server memcached