#!/usr/bin/env bash
echo "### Staring only the required containers ###"
docker-compose up -d workspace
docker-compose exec workspace bash

bash scripts/stop-workspace.sh
