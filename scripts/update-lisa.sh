#!/usr/bin/env bash
echo "### Using workspace to update BDO Lisa ###"
docker-compose up -d workspace

echo "### Updating composer ###"
docker-compose exec workspace bash -c "cd BDOLisa && composer install"

echo "### Updating yarn ###"
docker-compose exec workspace bash -c "cd BDOLisa && yarn install && yarn run production"

bash scripts/stop-workspace.sh
