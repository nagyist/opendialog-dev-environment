#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${DIR}/..

echo "### Rebuilding containers that use PHP ###"
docker-compose build workspace php-fpm
