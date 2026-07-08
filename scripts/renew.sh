#!/usr/bin/env bash

set -euo pipefail

if ! command -v docker >/dev/null 2>&1; then
    echo "error: docker is not available" >&2
    exit 1
fi
echo "docker found"

if ! docker compose version >/dev/null 2>&1; then
    echo "error: docker compose is not available" >&2
    exit 1
fi
echo "docker compose found"

if [[ -n "$(docker compose ps --status running nginx --quiet)" ]]; then
    echo "nginx is running, continuing"
else
    echo "nginx is not running, starting"
    docker compose up -d nginx
    trap 'docker compose down' EXIT
fi

echo "renewing certificates"
docker compose run --rm certbot renew

echo "done"
