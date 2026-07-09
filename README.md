# docker-nginx-certbot

> A minimal Docker setup for obtaining and automatically renewing Let's Encrypt SSL certificates.

## Features

- Automatic Let's Encrypt certificate management
- Minimal configuration
- Docker-based
- Suitable for users with little Linux experience

## Prerequisites

- Docker
- Docker Compose
- A domain name pointing to your server
- An email address for Let's Encrypt

## Installation

```bash
git clone https://github.com/Laith8/nginx-certbot-docker
```

```bash
cd nginx-certbot-docker
```

Edit the list of domains:

```bash
nano domains.list
```

Initialize the certificates using your email:
> If your user is in the `docker` group, `sudo` may not be required for docker related commands.

```bash
sudo ./scripts/init.sh --email email@example.com
```

Install the renewal cron job:

```bash
sudo ./scripts/croninstall.sh
```

## Usage

Start nginx:

```bash
sudo docker compose up -d nginx
```

Place your Nginx server configurations in `nginx/`.

After making changes, reload Nginx without downtime:

```bash
sudo docker exec nginx nginx -s reload
```

## Notes

- The project directory can be moved at any time.
- If you move it, run `sudo ./scripts/croninstall.sh` again from the new location so the renewal cron job uses the new path.
