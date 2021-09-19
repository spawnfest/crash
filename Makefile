all: init
.PHONY: init start up build shell shell-node install-deps compile halt test coverage format format-check check commit master-node node-one node-two clean

init: up install-deps compile

start: up install-deps compile migrate documentation				## Start application
	docker-compose exec crash mix s

up:																	## Start all services
	docker-compose up -d --remove-orphans

build:																## Build all services containers
	docker-compose build

shell: container-crash												## Enter into crash service
	docker-compose exec crash bash

shell-node: container-crash											## Enter into crash service with beam local-node name
	docker-compose exec crash iex --sname local-node -S mix

install-deps: container-crash										## Install crash dependencies
	docker-compose exec crash mix deps.get

compile: container-crash											## Compile crash application
	docker-compose exec crash mix cs

halt:																## Shoutdown all services containers
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

commit: container-crash												## Execute dynamic commit generation
	docker-compose exec -T crash mix generate_commit

master-node:														## Start master node
	docker-compose exec crash iex --sname master-node --cookie 98796e49-6e99-4b8f-8ee1-80c204723037 -S mix s

node-one:															## Start first node connected to master
	docker-compose exec crash-node-1 iex --sname node-1 --cookie 98796e49-6e99-4b8f-8ee1-80c204723037 -S mix

node-two:															## Start second node connected to master
	docker-compose exec crash-node-2 iex --sname node-2 --cookie 98796e49-6e99-4b8f-8ee1-80c204723037 -S mix

clean:																## Shoutdown services
	docker-compose down -v

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

delete:
	@docker images -a | grep "crash" | awk '{print $3}' | xargs docker rmi -f | docker ps -a | grep "crash" | awk '{print $1}' | xargs docker rm -v

container-%:
	@docker ps -q --no-trunc --filter status=running | grep $$(docker-compose ps -q $*) >/dev/null 2>&1 || docker-compose up -d $*
