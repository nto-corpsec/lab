#!/usr/bin/env bash
# Пин вендорных репозиториев. Идемпотентно: повторный запуск обновляет до тега.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENDOR="${ROOT}/vendor"
WAZUH_DOCKER_TAG="${WAZUH_DOCKER_TAG:-v4.14.9}"
WAZUH_DOCKER_URL="https://github.com/wazuh/wazuh-docker.git"

mkdir -p "${VENDOR}"
target="${VENDOR}/wazuh-docker"

if [[ -d "${target}/.git" ]]; then
  echo "wazuh-docker уже клонирован, обновляю до ${WAZUH_DOCKER_TAG}"
  git -C "${target}" fetch --depth 1 origin "refs/tags/${WAZUH_DOCKER_TAG}:refs/tags/${WAZUH_DOCKER_TAG}"
  git -C "${target}" checkout --detach "${WAZUH_DOCKER_TAG}"
else
  echo "клонирую wazuh-docker ${WAZUH_DOCKER_TAG}"
  git clone --depth 1 --branch "${WAZUH_DOCKER_TAG}" "${WAZUH_DOCKER_URL}" "${target}"
fi

echo "готово: ${target}"
echo "дальше: make siem"
