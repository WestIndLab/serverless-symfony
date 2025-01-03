include make/variables.mk

## —— 🚀 Serverless ——
.PHONY: serverless-* sls-* bref-*

SERVERLESS = $(shell pnpm bin)/serverless
AWS_PROFILE ?= default
DOCKER_COMPOSE_BREF = docker compose -f docker-compose.bref.yml

serverless-deploy: ## Déploie l'application sur AWS Lambda
	@echo "$(BLUE)Déploiement sur AWS...$(NC)"
	cd app/symfony && $(COMPOSER) install --no-dev --optimize-autoloader
	cd app/symfony && rm -rf var/cache/*
	cd app/symfony && $(SYMFONY) cache:clear --env=prod
	cd app/symfony && $(SYMFONY) asset-map:compile --env=prod
	cd app/symfony && $(SYMFONY) assets:install public --env=prod
	cd app/symfony && $(SERVERLESS) deploy --aws-profile $(AWS_PROFILE)

serverless-remove: ## Supprime le déploiement AWS
	@echo "$(RED)Suppression du déploiement...$(NC)"
	cd app/symfony && $(SERVERLESS) remove --aws-profile $(AWS_PROFILE)

serverless-info: ## Affiche les informations sur le déploiement
	@$(SERVERLESS) info --aws-profile $(AWS_PROFILE)

serverless-logs: ## Affiche les logs de la fonction Lambda
	@$(SERVERLESS) logs -f web --aws-profile $(AWS_PROFILE)

serverless-invoke: ## Invoque la fonction Lambda localement
	@$(SERVERLESS) invoke local -f web

serverless-offline: ## Lance le serveur en local
	@$(SERVERLESS) offline start

# Commandes Bref local
bref-start:
	@$(DOCKER_COMPOSE_BREF) up -d
	@echo "$(GREEN)Serveur Bref démarré sur http://localhost:8000$(NC)"

bref-stop:
	@$(DOCKER_COMPOSE_BREF) down

bref-logs:
	@$(DOCKER_COMPOSE_BREF) logs -f

bref-bash: 
	@$(DOCKER_COMPOSE_BREF) exec php bash

bref-restart: bref-stop bref-start

# Alias
sls-deploy: serverless-deploy
sls-remove: serverless-remove
sls-info: serverless-info
sls-logs: serverless-logs
sls-invoke: serverless-invoke
sls-offline: serverless-offline
