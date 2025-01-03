include make/variables.mk

## —— 🐳 Docker ——
.PHONY: build start stop restart logs bash bash-* ps

build: ## Construit les images Docker
	@$(DOCKER_COMPOSE) build --pull --no-cache

start: ## Démarre les conteneurs
	@$(DOCKER_COMPOSE) up -d

stop: ## Arrête les conteneurs
	@$(DOCKER_COMPOSE) stop

restart: stop start ## Redémarre les conteneurs

logs: ## Affiche les logs des conteneurs
	@$(DOCKER_COMPOSE) logs -f

ps: ## Liste les conteneurs
	@$(DOCKER_COMPOSE) ps

bash: ## Lance un terminal dans le conteneur PHP
	@$(DOCKER_EXEC) $(PHP_CONTAINER) bash

bash-root: ## Lance un terminal root dans le conteneur PHP
	@$(DOCKER_EXEC) --user root $(PHP_CONTAINER) bash

bash-nginx: ## Lance un terminal dans le conteneur Nginx
	@$(DOCKER_EXEC) nginx bash

bash-mysql: ## Lance un terminal dans le conteneur MySQL
	@$(DOCKER_EXEC) mysql bash
