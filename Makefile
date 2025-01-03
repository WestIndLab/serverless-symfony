# Inclusion des fichiers de configuration
include make/variables.mk
include make/docker.mk
include make/symfony.mk
include make/composer.mk
include make/database.mk
include make/serverless.mk

.PHONY: help install env-dev env-prod deploy

## —— 🎯 Actions principales ——
install: composer-install db-create db-migrate ## Installation initiale du projet
	@echo "$(GREEN)Projet installé$(NC)"

env-dev: ## Configure l'environnement en développement
	@echo "APP_ENV=dev" > .env.local
	@$(MAKE) cache-clear
	@echo "$(GREEN)Environnement dev configuré$(NC)"

env-prod: ## Configure l'environnement en production
	@echo "APP_ENV=prod" > .env.local
	@$(MAKE) cache-preload
	@echo "$(GREEN)Environnement prod configuré$(NC)"

deploy: env-prod serverless-deploy ## Déploie l'application sur AWS Lambda

help: ## Liste toutes les commandes
	@echo "$(YELLOW)Usage:$(NC)"
	@echo "  make [commande]"
	@echo ""
	@echo "$(YELLOW)Commandes disponibles:$(NC)"
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}'
