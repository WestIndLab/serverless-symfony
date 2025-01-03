include make/variables.mk

## —— 🔧 Database ——
.PHONY: db-*

db-create: ## Crée la base de données
	@$(SYMFONY) doctrine:database:create --if-not-exists
	@echo "$(GREEN)Base de données créée$(NC)"

db-drop: ## Supprime la base de données
	@$(SYMFONY) doctrine:database:drop --force --if-exists
	@echo "$(RED)Base de données supprimée$(NC)"

db-migrate: ## Lance les migrations
	@$(SYMFONY) doctrine:migrations:migrate --no-interaction
	@echo "$(GREEN)Migrations effectuées$(NC)"

db-fixtures: ## Charge les fixtures
	@$(SYMFONY) doctrine:fixtures:load --no-interaction
	@echo "$(GREEN)Fixtures chargées$(NC)"

db-reset: db-drop db-create db-migrate db-fixtures ## Reset complet de la base de données
	@echo "$(GREEN)Base de données réinitialisée$(NC)"
