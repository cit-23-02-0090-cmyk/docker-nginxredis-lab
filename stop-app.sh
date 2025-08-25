#!/bin/bash

echo "Stopping app ..."

docker stop nginx-container redis-container 2>/dev/null || true

echo "App stopped. Data preserved in redis-data volume."
echo "You can restart with: ./start-app.sh"
