#!/usr/bin/env bash
echo "### Rebuilding containers that use PHP ###"
docker-compose build workspace php-fpm php-worker

bash ./up-with-rebuild.sh