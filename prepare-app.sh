#!/bin/bash

echo "Preparing app ..."

docker network create my-app-network 2>/dev/null || echo "Network already exists, continuing..."

docker volume create redis-data 2>/dev/null || echo "Volume already exists, continuing..."

mkdir -p nginx-config

cat > nginx-config/default.conf << EOF
server {
    listen 80;
    server_name localhost;

    location / {
        root /usr/share/nginx/html;
        index index.html index.htm;
    }

    location /status {
        stub_status on;
        access_log off;
        allow all;
    }
}
EOF

mkdir -p html-content
cat > html-content/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>CIT-23-02-0090 - Docker App</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #333; }
        .container { max-width: 800px; margin: 0 auto; }
        .info { background: #f5f5f5; padding: 20px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to CIT-23-02-0090 Docker Application</h1>
        <div class="info">
            <p>This is a custom Docker web application with Nginx and Redis.</p>
            <p><strong>Registration Number:</strong> CIT-23-02-0090</p>
            <p><strong>Services:</strong> Nginx (Port 80), Redis (Port 6379)</p>
            <p><strong>Features:</strong> Persistent data storage, custom network</p>
        </div>
        <p>Application successfully deployed using Docker!</p>
    </div>
</body>
</html>
EOF

cat > Dockerfile << EOF
FROM nginx:alpine
COPY nginx-config/default.conf /etc/nginx/conf.d/default.conf
COPY html-content/index.html /usr/share/nginx/html/index.html
COPY html-content /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

echo "Building custom Nginx image..."
docker build -t custom-nginx:1.0 .

echo "App preparation complete."
echo "Network 'my-app-network' ready."
echo "Volume 'redis-data' ready."
echo "Custom Nginx image 'custom-nginx:1.0' built successfully."
