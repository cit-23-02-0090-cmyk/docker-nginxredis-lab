# CIT-23-02-0090 - Docker Web Application

## Deployment Requirements
- Docker Engine
- Bash terminal

## Application Description
Simple web application with:
- Nginx web server (port 80) with custom HTML page
- Redis database (port 6379) with persistence

## Network and Volume Details
- Network: `my-app-network` (bridge driver)
- Volume: `redis-data` (for Redis data persistence)

## Container Configuration
- **nginx-container**: 
  - Image: `custom-nginx:1.0` (custom built)
  - Port: 80:80
  - Network: my-app-network
  - Restart policy: unless-stopped

- **redis-container**:
  - Image: `redis:alpine`
  - Port: 6379:6379
  - Volume: redis-data:/data
  - Command: redis-server --appendonly yes
  - Network: my-app-network
  - Restart policy: unless-stopped

## Instructions

### 1. Prepare Application:
```bash
./prepare-app.sh
