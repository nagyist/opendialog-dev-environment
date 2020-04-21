#!/usr/bin/env bash
echo "### SSH to nginx ###"
docker-compose up -d nginx
docker-compose exec nginx bash
