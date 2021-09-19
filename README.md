# Crash

![Crash from Crash Bandicoot™](https://github.com/spawnfest/crash/blob/master/media/crash-bandicoot.png)

Crash is a simple (distributed) docker-on-docker Continuous Integration system written in Elixir - SpawnFest 2021

[![CI](https://github.com/spawnfest/crash/actions/workflows/crash-ci.yml/badge.svg)](https://github.com/spawnfest/crash/actions/workflows/crash-ci.yml)

## Requirements
  
  - docker **20+**
  - GNU make **4+**
  
## Development links

  * [Conventional Commits][1]
  * [Elixir Style Guide][2]

  [1]: https://www.conventionalcommits.org/en/v1.0.0/
  [2]: https://github.com/christopheradams/elixir_style_guide


## Getting started

#### make commands

```bash
build                          Build all services containers
check                          Execute static code analysis
clean                          Shoutdown services
commit                         Execute dynamic commit generation
compile                        Compile crash application
coverage                       Execute code coverage
format-check                   Execute code format verification
format                         Execute code formatting
halt                           Shoutdown all services containers
install-deps                   Install crash dependencies
master-node                    Start master node
node-one                       Start first node connected to master
node-two                       Start second node connected to master
shell                          Enter into crash service
shell-node                     Enter into crash service with beam local-node name
start                          Start application
test                           Execute crash suite test
up                             Start all services
```


## How to use

#### setup the project

```bash
make init
```

### run a single instance

```bash
make start
```

#### open http://localhost:3000/

#### simulate commit request

``` bash
make commit 
```

### run multiple instances

execute the following commands in separate sessions

``` bash
make master-node
make node-one
make node-two
```

![Example multinode](https://github.com/spawnfest/crash/blob/master/media/crash-multi-example.png)

#### open http://localhost:3000/

#### simulate commit request

``` bash
make commit 
```

![Example build](https://github.com/spawnfest/crash/blob/master/media/crash-build-example.png)


## Improvements / Missing parts / Bugs 

- add more integration / unit tests
- improve error handling inside gensever
- improve data visualization on UI
- add opentelemetry stuff
- with four or more builds the UI is broken
- fix mutation testing in CI
- TODO

## Why this project?

TODO add motivations
