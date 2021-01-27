#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${DIR}/..

CHOSEN_DATABASE=$(grep CHOSEN_DATABASE .env | xargs)
CHOSEN_DATABASE=${CHOSEN_DATABASE#*=}

echo "### Using workspace to update OpenDialog Conversations ###"
docker-compose up -d workspace dgraph-server dgraph-zero ${CHOSEN_DATABASE}

echo "### Updating webchat conversations ###"
docker-compose exec workspace bash -c "php artisan conversations:setup --non-interactive"

bash scripts/stop-workspace.sh
