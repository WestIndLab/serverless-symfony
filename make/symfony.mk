include make/variables.mk

## —— 🎵 Symfony ——
.PHONY: sf-* cache-* assets-*

sf-start: ## Démarre le serveur Symfony
	@$(SYMFONY) serve -d

sf-stop: ## Arrête le serveur Symfony
	@$(SYMFONY) serve:stop

cache-clear: ## Vide le cache
	@$(SYMFONY) cache:clear
	@echo "$(GREEN)Cache vidé$(NC)"

cache-warmup: ## Réchauffe le cache
	@$(SYMFONY) cache:warmup
	@echo "$(GREEN)Cache réchauffé$(NC)"

cache-preload: ## Génère le fichier de preload
	@$(SYMFONY) cache:clear --env=prod
	@$(SYMFONY) cache:warmup --env=prod
	@echo "$(GREEN)Fichier de preload généré dans var/cache/prod/App_KernelProdContainer.preload.php$(NC)"

assets-install: ## Installe les assets
	@$(SYMFONY) assets:install
	@echo "$(GREEN)Assets installés$(NC)"

tests: ## Lance les tests
	@$(DOCKER_EXEC) $(PHP_CONTAINER) php bin/phpunit
