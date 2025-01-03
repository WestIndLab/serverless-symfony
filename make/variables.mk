# Variables Docker
DOCKER_COMPOSE = docker compose
DOCKER_EXEC = $(DOCKER_COMPOSE) exec
PHP_CONTAINER = php
SYMFONY = $(DOCKER_EXEC) $(PHP_CONTAINER) php bin/console
COMPOSER = $(DOCKER_EXEC) $(PHP_CONTAINER) composer

# Couleurs
YELLOW = \033[33m
RED = \033[31m
GREEN = \033[32m
BLUE = \033[34m
NC = \033[0m
