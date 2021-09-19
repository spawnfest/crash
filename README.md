# Crash

![Crash from Crash Bandicoot™](https://github.com/spawnfest/crash/blob/master/media/crash-bandicoot.png)

Crash is a simple (distributed) docker-on-docker Continuous Integration system writter in Elixir - SpawnFest 2021

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


## How to USE

- TODO add description Here
- TODO add UI image with some builds
- TODO add console screenshot with multiple nodes


## Improvements / Missing 

- add more integration / unit tests
- improve error handling inside gensever
- add handle_info to match step errors and block build and return (instance.ex)
- improve data visualization on UI
- add opentelemetry stuff
- TODO
