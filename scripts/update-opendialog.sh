#!/usr/bin/env bash
echo "### Using workspace to update BDO OpenDialog ###"
docker-compose up -d workspace

echo "### Updating composer ###"
docker-compose exec workspace bash -c "cd BDOOpenDialog && composer install"

echo "### Updating yarn ###"
docker-compose exec workspace bash -c "cd BDOOpenDialog && yarn install && yarn run production"

echo "### Migrating ###"
docker-compose exec workspace bash -c "cd BDOOpenDialog && php artisan migrate"

echo "### Updating webchat ###"
docker-compose exec workspace bash -c "cd BDOOpenDialog && php artisan vendor:publish --tag=scripts --force && bash update-web-chat.sh -pify"

bash scripts/stop-workspace.sh
