# Crash

![Crash from Crash Bandicoot™](https://github.com/spawnfest/crash/blob/master/media/crash-bandicoot.png)

Crash is a simple docker-on-docker Continuous Integration System writter in Elixir - SpawnFest 2021

[![CI](https://github.com/spawnfest/crash/actions/workflows/crash-ci.yml/badge.svg)](https://github.com/spawnfest/crash/actions/workflows/crash-ci.yml)


## Development links

  * [Conventional Commits][1]
  * [Elixir Style Guide][2]

  [1]: https://www.conventionalcommits.org/en/v1.0.0/
  [2]: https://github.com/christopheradams/elixir_style_guide


## Getting started

#### Get all command list

```bash
make help
```

#### Build all services containers

```bash
make build
```

#### Execute static code analysis

```bash
make check
```

#### Shoutdown services

```bash
make clean
```

#### Compile crash application

```bash
make compile
```

#### Execute code coverage

```bash
make coverage
```

#### Execute code format verification

```bash
make format-check
```

#### Execute code formatting

```bash
make format
```

#### Shoutdown all services containers

```bash
make halt
```

#### Install crash dependencies

```bash
make install-deps
```

#### Enter into crash service

```bash
make shell
```

#### Enter into crash service with beam local-node name

```bash
make shell-node
```

#### Start application

```bash
make start
```

#### Execute crash suite test

```bash
make test
```

#### Start all services

```bash
make up
```
