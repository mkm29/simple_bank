.PHONY: help

help: ## This help.
	awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

postgres_up: ## Start postgres container
	@echo "Starting postgres container..."
	docker run -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_USER=simplebank \
  -p 5432:5432 \
  --name simplebank_db \
  -d postgres:12.15-alpine3.18

createdb: ## Create simplebank database
	@echo "Creating simplebank database..."
	docker exec -it simplebank_db createdb --username=simplebank --owner=simplebank simplebank

dropdb: ## Drop simplebank database
	@echo "Dropping simplebank database..."
	docker exec -it simplebank_db dropdb --username simplebank simplebank

migrateup: ## Migrate database to latest version
	@echo "Migrating database..."
	migrate -path internal/db/migrations -database "postgresql://simplebank:secret@localhost:5432/simplebank?sslmode=disable" -verbose up

migratedown: ## Rollback database version
	@echo "Rolling back database..."
	migrate -path internal/db/migrations -database "postgresql://simplebank:secret@localhost:5432/simplebank?sslmode=disable" -verbose down


dbgen: ## Generate database migration file
	@echo "Generating SQL with sqlc..."
	@sqlc generate

test: ## Run tests
	@echo "Running tests..."
	go test -v -cover ./...