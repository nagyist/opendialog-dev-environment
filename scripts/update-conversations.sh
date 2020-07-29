#!/usr/bin/env bash
echo "### Using workspace to update OpenDialog Conversations ###"
docker-compose up -d workspace dgraph-server dgraph-zero mysql

echo "### Updating webchat conversations ###"
docker-compose exec workspace bash -c "php artisan conversations:setup"

bash scripts/stop-workspace.sh
