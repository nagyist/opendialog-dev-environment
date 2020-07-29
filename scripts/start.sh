#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${DIR}/..

echo "### Starting required containers ###"
docker-compose up -d php-fpm mysql nginx dgraph-zero dgraph-server memcached
