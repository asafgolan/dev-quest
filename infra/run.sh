#!/usr/bin/env bash
# Start Caddy with secrets loaded from .env (which is gitignored).
set -euo pipefail
cd "$(dirname "$0")"

if [ ! -f .env ]; then
  echo "ERROR: .env not found. Run:  cp .env.example .env   then edit it." >&2
  exit 1
fi

# Export every var in .env into the environment Caddy reads ({$VAR} syntax).
set -a
# shellcheck disable=SC1091
source .env
set +a

exec caddy run --config Caddyfile --adapter caddyfile
