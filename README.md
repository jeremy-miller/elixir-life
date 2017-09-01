[![Build Status](https://travis-ci.org/jeremy-miller/life-elixir.svg?branch=master)](https://travis-ci.org/jeremy-miller/life-elixir)
[![Coverage Status](https://coveralls.io/repos/github/jeremy-miller/life-elixir/badge.svg?branch=master)](https://coveralls.io/github/jeremy-miller/life-elixir?branch=master)
[![Inline docs](http://inch-ci.org/github/jeremy-miller/life-elixir.svg)](http://inch-ci.org/github/jeremy-miller/life-elixir)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/jeremy-miller/life-elixir/blob/master/LICENSE)
[![Elixir Version](https://img.shields.io/badge/Elixir-1.4-blue.svg)]()
[![Erlang/OTP Version](https://img.shields.io/badge/Erlang%2FOTP-19.3-blue.svg)]()

# Life (in Elixir)
Elixir implementation of [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life).
The application logic is based on
[this](http://www.east5th.co/blog/2017/02/06/playing-the-game-of-life-with-elixir-processes/) blog.
The web server implementation is based on
[this](http://www.east5th.co/blog/2017/02/20/rendering-life-on-a-canvas-with-phoenix-sockets/) blog.

## Tasks
- Dropdown selection for which type of pattern to use
- Example usage gif

## Table of Contents
- [Motivation](#motivation)
- [Usage](#usage)
  - [Prerequisites](#prerequisites)
  - [Build](#build)
  - [Code Formatting](#code-formatting)
  - [Dependencies](#dependencies)
  - [Elixir Static Code Analysis](#elixir-static-code-analysis)
  - [Non-Elixir Static Code Analysis](#non-elixir-static-code-analysis)
  - [Test](#test)
  - [Run](#run)
- [License](#license)

## Motivation
I created this project for three reasons:

1. To use Elixir's "process-first" approach to implement Conway's Game of Life.
2. To compare a "process-first" implementation of Conway's Game of Life with my
[Clojure](https://github.com/jeremy-miller/life-clojure) and
[Python](https://github.com/jeremy-miller/life-python) implementations.
3. Try out Elixir's [Phoenix](http://phoenixframework.org/) web framework.

## Usage
This implementation uses a Docker container to isolate the execution environment.

### Prerequisites
- [Docker](https://docs.docker.com/engine/installation/)

### Build
Before interacting with the Life game, the Docker container must be built:
```docker build -t jeremymiller/life-elixir .```

*NOTE: This may take a long time since it creates the Persistent Lookup Table (PLT) for Dialyzer
(see [here](https://github.com/jeremyjh/dialyxir#plt) for more information).*

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

### Non-Elixir Static Code Analysis
Before running any non-Elixir static code analysis tools, the Docker container containing the tools must be downloaded:
```docker pull jeremymiller/node-lint```

To run [Dockerfilelint](https://www.npmjs.com/package/dockerfilelint) on the `Dockerfile` in this repository, execute the following command:
```docker run -it --rm -v $PWD:/usr/src/app jeremymiller/node-lint dockerfile_lint -r .dockerfilelintrc -f app/Dockerfile```

To run [markdownlint](https://github.com/DavidAnson/markdownlint) on this `README.md`, execute the following command:
```docker run -it --rm -v $PWD:/usr/src/app jeremymiller/node-lint markdownlint app/README.md```

### Test
To run the Life tests, execute the following command:
```docker run -it --rm --env MIX_ENV=test jeremymiller/life-elixir mix test```

To run the Life tests automatically on save during local development, execute the following command:
```docker run -it --rm --env MIX_ENV=dev -v $PWD:/usr/src/app/ jeremymiller/life-elixir mix test.watch```

### Run
To compile the Life application and run the *iex* REPL, execute the following command:
```docker run -it --rm --env MIX_ENV=prod jeremymiller/life-elixir```

## License
[MIT](https://github.com/jeremy-miller/life-elixir/blob/master/LICENSE)
