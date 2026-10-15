# Dockerized Website & Server Monitoring

## Overview
A Bash-based monitoring tool packaged with Docker. It checks website availability, records HTTP status codes, collects basic container-environment resource metrics, and stores timestamped logs.

## Technologies
- Bash scripting
- Linux
- Docker
- Docker Compose
- curl
- Git and GitHub

## Features
- Monitors multiple websites
- Detects connection failures and HTTP errors
- Collects CPU load average, memory usage, and disk usage
- Writes timestamped monitoring logs
- Rotates logs when they reach approximately 1 MB
- Runs continuously inside a Docker container

## Run locally
```bash
docker compose up -d --build
docker compose ps
docker compose logs -f
```

## View saved logs
```bash
tail -f logs/monitor.log
```

## Stop the project
```bash
docker compose down
```

## Learning outcomes
Practiced Bash functions, arrays, loops, conditional statements, Linux commands, Docker image creation, Compose configuration, persistent volumes, logging, and restart policies.

**Note:** Resource metrics collected inside the container describe its environment and are not necessarily host-wide measurements.
