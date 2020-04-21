#!/usr/bin/env bash
echo "### Starting required containers ###"
docker-compose up -d php-fpm mysql nginx zero server memcached
