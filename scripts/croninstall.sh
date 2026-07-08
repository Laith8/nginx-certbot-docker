#!/usr/bin/env bash

set -euo pipefail

echo "installing cronjob"

cat > /etc/cron.d/certbotrenew.cron <<EOF
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

42 3 * * 0 root "${PWD}/scripts/renew.sh"
EOF

chmod 644 /etc/cron.d/certbotrenew.cron

echo "done"
