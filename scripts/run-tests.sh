#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${DIR}/..

bash ${DIR}/start-test-containers.sh

echo "### Running Test suite ###"

docker-compose exec workspace php vendor/phpunit/phpunit/phpunit

bash ${DIR}/stop-test-containers.sh