[![Build Status](https://travis-ci.org/jeremy-miller/life-elixir.svg?branch=master)](https://travis-ci.org/jeremy-miller/life-elixir)
[![Inline docs](http://inch-ci.org/github/jeremy-miller/life-elixir.svg)](http://inch-ci.org/github/jeremy-miller/life-elixir)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/jeremy-miller/life-elixir/blob/master/LICENSE)
<!-- markdownlint-disable MD042 -->
[![Elixir Version](https://img.shields.io/badge/Elixir-1.4-blue.svg)]()

# Life (in Elixir)
Elixir implementation of [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life).
This project is based on [this](http://www.east5th.co/blog/2017/02/06/playing-the-game-of-life-with-elixir-processes/)
blog.

## Tasks
- Move Dialyzer inside Docker, update Dockerfile
- Remove private function docs (inline "why" comments), improve public function docs
- Move test.watch to Docker container with volume, add inotify-tools to Dockerfile
- Push to/pull from Dockerhub
- Deploy to AWS/etc? Terraform? Ansible?
- Add other linters to CI/CD process (markdownlint, dockerfile lint, etc)
- Dialyzer
- Tests
  - ExUnit
  - Doctests
  - Quixir
- Code coverage
- Phoenix
- D3
- Dropdown selection for which type of pattern to use
- Example usage gif

## Table of Contents
- [Motivation](#motivation)
- [Usage](#usage)
  - [Prerequisites](#prerequisites)
  - [Build](#build)
  - [Code Formatting](#code-formatting)
  - [Dependencies](#dependencies)
  - [Static Code Analysis](#static-code-analysis)
  - [Test](#test)
  - [Run](#run)
- [License](#license)

## Motivation
I created this project for two reasons:

1. To use Elixir's "process-first" approach to implement Conway's Game of Life.
2. To compare a "process-first" implementation of Conway's Game of Life with my
[Clojure](https://github.com/jeremy-miller/life-clojure) and
[Python](https://github.com/jeremy-miller/life-python) implementations.

## Usage
This implementation uses a Docker container to isolate the execution environment.

### Prerequisites
- [Docker](https://docs.docker.com/engine/installation/)

### Build
Before interacting with the Life game, the Docker container must be built:
```docker build -t jeremymiller/life-elixir .```

### Code Formatting
To run the [exfmt](https://github.com/lpil/exfmt) code formatter, execute the following command (substituting a file path):
```docker run -it --rm --env MIX_ENV=dev jeremymiller/life-elixir mix exfmt <path to file>```

### Dependencies
To check for outdated dependencies, execute the following command:
```docker run -it --rm --env MIX_ENV=dev jeremymiller/life-elixir mix hex.outdated```

### Static Code Analysis
To run the [Credo](https://github.com/rrrene/credo) static code analyzer, execute the following command:
```docker run -it --rm --env MIX_ENV=dev jeremymiller/life-elixir mix credo --strict```

To run the [Dialyzer](http://erlang.org/doc/man/dialyzer.html) static code analyzer, execute the following command:
```docker run -it --rm --env MIX_ENV=dev jeremymiller/life-elixir mix dialyzer```
*NOTE: The first time this command is run it may take a long time since it needs to create the PLT (see
[here](https://github.com/jeremyjh/dialyxir#usage) for more information).*

### Test
To run the Life tests, execute the following command:
```docker run -it --rm --env MIX_ENV=test jeremymiller/life-elixir mix test```

To run the Life tests automatically on save during local development, execute the following command:
```mix test.watch```

### Run
To compile the Life application and run the *iex* REPL, execute the following command:
```docker run -it --rm --env MIX_ENV=prod jeremymiller/life-elixir```

## License
[MIT](https://github.com/jeremy-miller/life-elixir/blob/master/LICENSE)
