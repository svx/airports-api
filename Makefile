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
APPLICATION_NAME ?= planet-api
NAME = testthedocs/planet-api
DOCKER := $(bash docker)
GIT_HASH ?= $(shell git log --format="%h" -n 1)

# Vars
# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
.PHONY: help
help: ## This help message
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[35m\1\\x1b[m:\2/' | column -c2 -t -s :)"

.PHONY: start-api
start-api: ## Starts API locally in dev mode
# Todo: create env in pwd and adjust script
	@.././env/bin/uvicorn app.main:app --reload

.PHONY: save-openapi-spec
save-openapi-spec: ## Saves OpenAPI spec locally
	@curl -O localhost:8000/openapi.json

.PHONY: serve-redoc-docs
serve-openapi-docs: ## Starts redoc container serving the OpenAPI spec on port 8080
	@docker run -p 8080:80 -e SPEC_URL=https://raw.githubusercontent.com/svx/basic-planets-api/main/openapi.json redocly/redoc

.PHONY: serve-swagger-ui-docs
serve-swagger-ui-docs: ## Starts Swagger UI serving the OpenAPI spec on port 8080
	@docker run -p 80:8080 -e SWAGGER_JSON_URL=https://raw.githubusercontent.com/svx/basic-planets-api/main/openapi.json swaggerapi/swagger-ui

.PHONY: docker-build
docker-build: ## Build production image
	@docker build --no-cache=true --tag ${DOCKER_USERNAME}/${APPLICATION_NAME} -f Dockerfile .

.PHONY: docker-run
docker-run: ## Start container locally on port 8080
	@echo "$(YELLOW)==> Please open your browser localhost:8080$(RESET)"
	@docker run --rm -p 8080:8080 --name api-test ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest

.PHONY: release-build
release-build: ## Build images for Mac silicon and linux amd64
	@docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag ${DOCKER_USERNAME}/${APPLICATION_NAME}:${GIT_HASH} --tag ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest .

.PHONY: push
push: ## Push to Docker Hub
	@docker push ${DOCKER_USERNAME}/${APPLICATION_NAME}:${GIT_HASH}

.PHONY: release
release: ## Release on Docker Hub
	@docker pull ${DOCKER_USERNAME}/${APPLICATION_NAME}:${GIT_HASH}
	@docker tag  ${DOCKER_USERNAME}/${APPLICATION_NAME}:${GIT_HASH} ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest
	@docker push ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest

	docker image push --all-tags registry-host:5000/myname/myimage