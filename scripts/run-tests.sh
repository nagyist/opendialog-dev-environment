#!/usr/bin/env bash

source ./scripts/init.sh

bash ${DIR}/start-test-containers.sh

echo "### Running Test suite ###"

docker-compose -f ${COMPOSE_FILE} exec workspace php vendor/phpunit/phpunit/phpunit

bash ${DIR}/stop-test-containers.sh
