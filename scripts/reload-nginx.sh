#!/usr/bin/env bash
echo "### Reloading NGINX ###"
docker-compose up -d nginx
docker-compose exec nginx nginx -s reload
