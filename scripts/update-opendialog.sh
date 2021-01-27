#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${DIR}/..

echo "### Using workspace to update BDO OpenDialog ###"
docker-compose up -d workspace

echo "### Updating composer ###"
docker-compose exec workspace bash -c "composer install"

echo "### Updating yarn ###"
docker-compose exec workspace bash -c "yarn install && yarn run production"

echo "### Migrating ###"
docker-compose exec workspace bash -c "php artisan migrate"

echo "### Updating webchat ###"
docker-compose exec workspace bash -c "php artisan vendor:publish --tag=scripts --force && bash update-web-chat.sh -ify"

bash scripts/stop-workspace.sh
