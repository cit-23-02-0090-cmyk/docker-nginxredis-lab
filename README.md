#  Dockerized Nginx and Redis Web Application

A small multi-container application built with Docker. It runs a custom-built Nginx web server and a Redis database on a shared network, with Redis data persisted in a named volume. Four Bash scripts handle the full lifecycle: prepare, start, stop and remove.

## Architecture

| Component | Details |
|---|---|
| **nginx-container** | Image `custom-nginx:1.0` (built from `nginx:alpine`), host port `80`, serves a custom HTML page and a `/status` endpoint |
| **redis-container** | Image `redis:alpine`, host port `6379`, append-only persistence enabled |
| **Network** | `my-app-network` (user-defined bridge), lets the containers reach each other by name |
| **Volume** | `redis-data`, mounted at `/data` in the Redis container |
| **Restart policy** | `unless-stopped` on both containers |

## Repository Structure

```
.
├── Dockerfile              # Builds the custom Nginx image
├── nginx-config/
│   └── default.conf        # Nginx server configuration
├── html-content/
│   └── index.html          # Custom web page
├── prepare-app.sh          # Creates network and volume, builds the image
├── start-app.sh            # Starts the Redis and Nginx containers
├── stop-app.sh             # Stops the containers (data is kept)
├── remove-app.sh           # Removes containers, network and volume
└── README.md
```

## Prerequisites

- Linux, macOS, or Windows with WSL
- Docker Engine installed and running (`docker --version`)
- A Bash terminal
- Ports `80` and `6379` free on the host

## Usage

Make the scripts executable once:

```bash
chmod +x *.sh
```

### 1. Prepare the application

Creates the network and volume, then builds the custom Nginx image.

```bash
./prepare-app.sh
```

### 2. Start the application

```bash
./start-app.sh
```

The web page is then available at `http://localhost` and Redis at `localhost:6379`.

### 3. Stop the application

Stops both containers. Redis data stays in the `redis-data` volume.

```bash
./stop-app.sh
```

To bring it back, run `./start-app.sh` again. If the containers still exist from an earlier run, remove them first with `./remove-app.sh`, or start them with `docker start redis-container nginx-container`.

### 4. Remove the application

Deletes the containers, the network and the volume. **This permanently deletes the Redis data.**

```bash
./remove-app.sh
```

## Verifying the Deployment

Check that both containers are running:

```bash
docker ps
```

Check the web server and its status endpoint:

```bash
curl http://localhost
curl http://localhost/status
```

Check that Redis responds:

```bash
docker exec redis-container redis-cli ping
# Expected output: PONG
```

Check that the containers can reach each other over the custom network:

```bash
docker exec nginx-container ping -c 2 redis-container
```

### Testing data persistence

```bash
# 1. Store a value
docker exec redis-container redis-cli set testkey "hello"

# 2. Restart the Redis container
docker restart redis-container

# 3. Read the value back (it should still return "hello")
docker exec redis-container redis-cli get testkey
```

The value survives the restart because Redis runs with `--appendonly yes` and writes to the `redis-data` volume.

## Monitoring and Troubleshooting

View logs:

```bash
docker logs nginx-container
docker logs redis-container
```

Inspect the network and volume:

```bash
docker network inspect my-app-network
docker volume inspect redis-data
```

| Problem | Likely cause and fix |
|---|---|
| `port is already allocated` on port 80 | Another service (Apache, Nginx, another container) is using the port. Stop it, or change the host port in `start-app.sh` (e.g. `-p 8080:80`). |
| `container name is already in use` | Old containers still exist. Run `./remove-app.sh`, then start again. |
| `permission denied` when running a script | Run `chmod +x *.sh`. |
| `permission denied` connecting to the Docker daemon | Add your user to the `docker` group, or run with `sudo`. |
| Page shows the default Nginx welcome page | The image was not rebuilt. Run `./prepare-app.sh` again. |

## Security Notes

This project is a learning lab. Before using a similar setup anywhere real, note the following:

- **Redis has no password and its port is published on the host.** For anything beyond local testing, bind it to localhost only (`-p 127.0.0.1:6379:6379`), or do not publish the port and let Nginx reach it over `my-app-network`. Also set a password with `--requirepass`.
- **The `/status` endpoint allows all clients.** In a real deployment, restrict it (for example `allow 127.0.0.1; deny all;`).
- **Image tags are not pinned to exact versions** (`nginx:alpine`, `redis:alpine`). Pinning versions makes deployments reproducible.
- **Redis data is not backed up automatically.** The volume protects against container restarts, not against volume deletion or disk failure.

## What This Project Demonstrates

- Building a custom image with a Dockerfile
- User-defined bridge networking between containers
- Persistent storage with named volumes
- Container restart policies
- Automating deployment and cleanup with Bash scripts

## Author

M.W.P. Dewmi Abeykoon (CIT-23-02-0090), Sri Lanka Technology Campus
