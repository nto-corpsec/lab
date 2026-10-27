#!/usr/bin/env bash
# Обёртка над docker compose для повседневных операций стенда.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE="docker compose"
SIEM_DIR="${ROOT}/vendor/wazuh-docker/single-node"

usage() {
  cat <<'USAGE'
usage: lab.sh <command>

  up        поднять веб-цели (127.0.0.1:3000, 127.0.0.1:8081)
  down      погасить всё и удалить тома
  siem      поднять Wazuh single-node (нужен make vendor)
  siem-down погасить Wazuh
  status    статус контейнеров
  reset     сброс стенда и логов Zeek
USAGE
}

case "${1:-}" in
  up)        ${COMPOSE} --profile web up -d ;;
  down)      ${COMPOSE} --profile web --profile net --profile sandbox down -v ;;
  siem)      ${COMPOSE} -f "${SIEM_DIR}/docker-compose.yml" up -d ;;
  siem-down) ${COMPOSE} -f "${SIEM_DIR}/docker-compose.yml" down ;;
  status)    ${COMPOSE} ps ;;
  reset)     ${COMPOSE} --profile web --profile net --profile sandbox down -v
             rm -rf "${ROOT}/logs/zeek/"* ;;
  *)         usage; exit 2 ;;
esac
