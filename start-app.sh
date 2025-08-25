echo "Running app ..."

docker run -d \
  --name redis-container \
  --network my-app-network \
  -v redis-data:/data \
  -p 6379:6379 \
  --restart unless-stopped \
  redis:alpine redis-server --appendonly yes

docker run -d \
  --name nginx-container \
  --network my-app-network \
  -p 80:80 \
  --restart unless-stopped \
  custom-nginx:1.0

echo "The app is available at: http://localhost:80"
echo "Redis is available at: localhost:6379"
echo "Containers started with restart policy: unless-stopped"
