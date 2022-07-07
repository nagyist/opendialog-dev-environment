#!/usr/bin/env bash
source ./scripts/init.sh

echo "### Using workspace to update BDO OpenDialog ###"
docker-compose -f ${COMPOSE_FILE} up -d workspace

echo "### Updating composer ###"
docker-compose -f ${COMPOSE_FILE} exec workspace bash -c "composer install"

echo "### Updating yarn ###"
docker-compose -f ${COMPOSE_FILE} exec workspace bash -c "yarn install && yarn run production"

echo "### Migrating ###"
docker-compose -f ${COMPOSE_FILE} exec workspace bash -c "php artisan migrate"

bash scripts/stop-workspace.sh
