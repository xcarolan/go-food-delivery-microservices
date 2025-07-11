GOPATH:=$(shell go env GOPATH)

.PHONY: run
run:
	go run ./cmd/app/main.go

.PHONY: build
build:
	go build ./cmd/app/main.go

.PHONY: test
test:
	go test -cover ./...

.PHONY: lint
lint:
	revive -config revive-config.toml -formatter friendly ./...
	staticcheck ./...
	golangci-lint run ./...

.PHONY: format
format:
	golines -m 120 -w --ignore-generated .
	gci write --skip-generated -s standard -s "prefix(github.com/mehdihadeli/go-food-delivery-microservices)" -s default -s blank -s dot --custom-order  .
	gofumpt -l -w .

.PHONY: update
update:
	@go get -u

.PHONY: tidy
tidy:
	go mod tidy

.PHONY: deps-reset
deps-reset:
	git checkout -- go.mod
	go mod tidy

.PHONY: deps-upgrade
deps-upgrade:
	go get -u -t -d -v ./...
	go mod tidy

.PHONY: deps-cleancache
deps-cleancache:
	go clean -modcache

# ==============================================================================
# Linters https://golangci-lint.run/usage/install/
.PHONY: run-linter
run-linter:
	@echo Starting linters
	golangci-lint run ./...

.PHONY: docker
docker:
	@docker build -t go-catalogs-write:latest .

# ==============================================================================
# Go migrate postgresql https://github.com/golang-migrate/migrate

DB_NAME = catalogs.service
DB_HOST = localhost
DB_USER = postgres
DB_PASS = postgres
DB_HOST = localhost
DB_PORT = 5432
SSL_MODE = disable

# go the last successful version, which is 1 here
# https://github.com/golang-migrate/migrate/blob/master/GETTING_STARTED.md#forcing-your-database-version
# https://github.com/golang-migrate/migrate/issues/282#issuecomment-530743258
# https://github.com/golang-migrate/migrate/issues/35
# https://github.com/golang-migrate/migrate/issues/21
# https://dev.to/techschoolguru/how-to-write-run-database-migration-in-golang-5h6g

.PHONY: postgres
postgres:
	docker run --name postgres -p $(DB_PORT):$(DB_PORT) -e POSTGRES_USER=$(DB_USER) -e POSTGRES_PASSWORD=$(DB_PASS) -d postgres:11.1-alpine

.PHONY: create_db
create_db:
	docker exec -it postgres createdb -U $(DB_USER) -O $(DB_USER) $(DB_NAME)

.PHONY: drop_db
drop_db:
	docker exec -it postgres dropdb -U $(DB_USER) $(DB_NAME)
