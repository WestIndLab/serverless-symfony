include make/variables.mk

## —— 🎼 Composer ——
.PHONY: composer-*

composer-install: ## Installe les dépendances
	@$(COMPOSER) install
	@echo "$(GREEN)Dépendances installées$(NC)"

composer-update: ## Met à jour les dépendances
	@$(COMPOSER) update
	@echo "$(GREEN)Dépendances mises à jour$(NC)"

composer-validate: ## Valide le composer.json
	@$(COMPOSER) validate
	@echo "$(GREEN)Composer.json validé$(NC)"
