COMPOSE ?= docker compose
SIEM_DIR := vendor/wazuh-docker/single-node

.PHONY: vendor up down siem siem-down status reset check

vendor:
	./scripts/clone-vendor.sh

up:
	$(COMPOSE) --profile web up -d

down:
	$(COMPOSE) --profile web --profile net --profile sandbox down -v

siem: vendor
	$(COMPOSE) -f $(SIEM_DIR)/docker-compose.yml up -d

siem-down:
	$(COMPOSE) -f $(SIEM_DIR)/docker-compose.yml down

status:
	$(COMPOSE) ps

reset:
	$(COMPOSE) --profile web --profile net --profile sandbox down -v
	rm -rf logs/zeek/*

check:
	$(COMPOSE) config -q
	shellcheck scripts/*.sh
