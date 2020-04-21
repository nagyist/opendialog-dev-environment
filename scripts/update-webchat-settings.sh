#!/usr/bin/env bash
echo "### Using workspace to update BDO OpenDialog Conversations ###"
docker-compose up -d workspace server zero mysql

echo "### Updating webchat conversations ###"
docker-compose exec workspace bash -c "cd BDOOpenDialog && php artisan webchat:setup"

bash scripts/stop-workspace.sh
