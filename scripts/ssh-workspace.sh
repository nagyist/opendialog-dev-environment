#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${DIR}/..

echo "### Starting only the required containers ###"
docker-compose up -d workspace
docker-compose exec workspace bash

bash scripts/stop-workspace.sh
