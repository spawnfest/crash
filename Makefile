all: init
.PHONY: init start up build shell shell-node install-deps compile halt test coverage format format-check check clean

init: up install-deps compile

start: up install-deps compile migrate documentation				## Start application
	docker-compose exec crash mix s

up:																	## Start all services
	docker-compose up -d --remove-orphans

build:																## Build all services
	docker-compose build

shell: container-crash												## Enter into crash service
	docker-compose exec crash bash

shell-node: container-crash											## Enter into crash service with beam local-node name
	docker-compose exec crash iex --sname local-node -S mix

install-deps: container-crash										## Install crash dependencies
	docker-compose exec crash mix deps.get

compile: container-crash											## Compile crash application
	docker-compose exec crash mix cs

halt:																## Shoutdown all services
	docker-compose down

test: container-crash												## Execute crash suite test
	docker-compose exec -T crash mix test --color

coverage: container-crash											## Execute code coverage
	docker-compose exec -T crash mix coveralls --color

format: container-crash												## Execute code formatting
	docker-compose exec -T crash mix format.all

format-check: container-crash										## Execute code format verification
	docker-compose exec -T crash mix format.check

check: container-crash												## Execute static code analysis
	docker-compose exec -T crash mix check

clean:																## Shoutdown services
	docker-compose down -v

help:
	@perl -e '$(HELP_FUNC)' $(MAKEFILE_LIST)

delete:
	@docker images -a | grep "crash" | awk '{print $3}' | xargs docker rmi -f | docker ps -a | grep "crash" | awk '{print $1}' | xargs docker rm -v

container-%:
	@docker ps -q --no-trunc --filter status=running | grep $$(docker-compose ps -q $*) >/dev/null 2>&1 || docker-compose up -d $*
