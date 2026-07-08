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

DOMAINS=$(grep -Ev '^[[:space:]]*#|^[[:space:]]*$' domains.list | xargs)
echo "found domains: ${DOMAINS}"

DOMAINARGS=()

for domain in $DOMAINS; do
    DOMAINARGS+=(--domain "$domain")
done

EMAIL=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --email)
            EMAIL="$2"
            shift 2
            ;;
        *)
            echo "unknown argument: $1" >&2
            exit 1
            ;;
    esac
done

if [[ -z "$EMAIL" ]]; then
    echo "error: --email is required" >&2
    exit 1
fi

if [[ -d "certbot/conf/live/certificates" ]]; then
    echo "found exitsting certificates"
    echo "Exit(E)/Continue(c)/Renew(r)"
    read -rp "(E/c/r)>: " choice
    choice="${choice:-E}"

    case "${choice^^}" in
        E)
            echo "Exiting"
            exit 0
            ;;
        C)
            echo "Continuing"
            ;;
        R)
            echo "Renewing"
            ./scripts/renew.sh
            exit 0
            ;;
        *)
            echo "Invalid choice: $choice"
            exit 1
            ;;
    esac
fi

echo "creating nececarry directories"
mkdir -p certbot

if [[ -n "$(docker compose ps --status running nginx --quiet)" ]]; then
    echo "nginx is running, continuing"
else
    echo "nginx is not running, starting"
    docker compose up -d nginx
    trap 'docker compose down' EXIT
fi

docker compose run --rm certbot certonly --cert-name certificates --agree-tos -m ${EMAIL} --non-interactive --webroot --expand -w /var/www/certbot ${DOMAINARGS[@]};

echo "done"
