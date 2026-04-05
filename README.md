# Homework: Docker

This project includes a Dockerized Django app with PostgreSQL and Nginx.

## Services

- `web`: Django application running on port 8000 inside the container.
- `db`: PostgreSQL database.
- `nginx`: Reverse proxy on port 80.

## Quick start

```bash
docker-compose up -d
```

Then open: http://localhost

## Project layout

- `Dockerfile` builds the Django service image.
- `docker-compose.yml` defines `web`, `db`, and `nginx`.
- `nginx/nginx.conf` proxies traffic to the Django service.
- `config/` contains the Django settings and URLs.
