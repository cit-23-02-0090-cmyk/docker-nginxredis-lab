#!/bin/bash

echo "Removing app ..."a
docker rm -f nginx-container redis-container 2>/dev/null || true

docker network rm my-app-network 2>/dev/null || true

docker volume rm redis-data 2>/dev/null || true

echo "App completely removed. All resources cleaned up."

