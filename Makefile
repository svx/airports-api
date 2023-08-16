# The shell we use
SHELL := /bin/bash

# We like colors
# From: https://coderwall.com/p/izxssa/colored-makefile-for-golang-projects
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`
YELLOW=`tput setaf 3`

# Vars
DOCKER_USERNAME ?= testthedocs
APPLICATION_NAME ?= airports-api
DOCKER := $(bash docker)
GIT_HASH ?= $(shell git log --format="%h" -n 1)

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
.PHONY: help
help: # This help message
	@grep -E '^[a-z.A-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: dev-setup
dev-setup: ## Create virtualenv and install requirements
	@echo "$(YELLOW)==> Creating dev environment$(RESET)"
	@python3 -m venv env
	@./env/bin/pip install -r requirements.txt

.PHONY: dev-start-api-v1
dev-start-api-v1: ## Starts API locally in dev mode
	@echo "$(YELLOW)==> Starting API locally in dev mode$(RESET)"
	@./env/bin/uvicorn app.v1.main:app --reload

.PHONY: dev-start-api-v2
dev-start-api-v2: ## Starts API locally in dev mode
	@echo "$(YELLOW)==> Starting API locally in dev mode$(RESET)"
	@./env/bin/uvicorn app.v2.main:app --port 9000 --reload

# .PHONY: save-openapi-spec
# save-openapi-spec: ## Saves OpenAPI spec locally
# 	@curl -O localhost:8000/openapi.json

.PHONY: save-openapi-spec-v1
save-openapi-spec-v1: ## Saves OpenAPI spec of v1 locally
	@curl -o openapi-v1.json localhost:8000/openapi.json

.PHONY: save-openapi-spec-v2
save-openapi-spec-v2: ## Saves OpenAPI spec of v2 locally
	@curl -o openapi-v2.json localhost:9000/openapi.json

# .PHONY: serve-redoc-docs
# serve-openapi-docs: ## Starts redoc container serving the OpenAPI spec on port 8080
# 	@docker run -p 8080:80 -e SPEC_URL=https://raw.githubusercontent.com/svx/basic-planets-api/main/openapi.json redocly/redoc

# swaggerapi/swagger-ui currently does not support Apple silicon
# .PHONY: serve-swagger-ui-docs
# serve-swagger-ui-docs: ## Starts Swagger UI serving the OpenAPI spec on port 8080
# 	@docker run -p 80:8080 -e SWAGGER_JSON_URL=https://raw.githubusercontent.com/svx/basic-planets-api/main/openapi.json swaggerapi/swagger-ui

.PHONY: docker-build-v1
docker-build-v1: ## Build production image of API v1
	@docker build --no-cache=true --tag ${DOCKER_USERNAME}/${APPLICATION_NAME}-v1 -f v1.Dockerfile .

.PHONY: docker-build-v2
docker-build-v2: ## Build production image of API v2
	@docker build --no-cache=true --tag ${DOCKER_USERNAME}/${APPLICATION_NAME}-v2 -f v2.Dockerfile .

.PHONY: docker-run
docker-run: ## Start container locally on port 8080
	@echo "$(YELLOW)==> Please open your browser localhost:8080$(RESET)"
	@docker run --rm -p 8080:8080 --name api-test ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest

.PHONY: release-v1
release-v1: ## Build images for Apple silicon and Linux amd64 and push to Docker Hub of API v1
	@echo "$(YELLOW)==> Building images and pushing them to Docker Hub$(RESET)"
	@docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag ${DOCKER_USERNAME}/${APPLICATION_NAME}-v1:${GIT_HASH} --tag ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest -f v1.Dockerfile

.PHONY: release-v2
release-v2: ## Build images for Apple silicon and Linux amd64 and push to Docker Hub of API v1
	@echo "$(YELLOW)==> Building images and pushing them to Docker Hub$(RESET)"
	@docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag ${DOCKER_USERNAME}/${APPLICATION_NAME}-v2:${GIT_HASH} --tag ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest f v2.Dockerfile

.PHONY: push
push: ## Push to Docker Hub
	@docker push ${DOCKER_USERNAME}/${APPLICATION_NAME}:${GIT_HASH}

