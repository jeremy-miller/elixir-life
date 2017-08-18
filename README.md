[![MIT Licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/jeremy-miller/portals/blob/master/LICENSE)
[![Elixir Version](https://img.shields.io/badge/Elixir-1.4-blue.svg)]()

# Life (in Elixir)
Elixir implementation of [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life).
This project is based on [this](http://www.east5th.co/blog/2017/02/06/playing-the-game-of-life-with-elixir-processes/) blog.

## Tasks
- Credo
- Exfmt
- Dialyzer
- Tests
- Travis
- Code coverage
- Docker
- Phoenix
- D3

<details>
<summary><strong>Table of Contents</strong></summary>

* [Motivation](#motivation)
* [Usage](#usage)
  + [Prerequisites](#prerequisites)
  + [Build](#build)
  + [Static Code Analysis](#static-code-analysis)
  + [Test](#test)
  + [Run](#run)
* [License](#license)
</details>

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
Before interacting with the Life game, the Docker container must be built: ```docker build -t jeremymiller/life-elixir .```

### Static Code Analysis
To run the [Credo](https://github.com/rrrene/credo) static code analyzer, execute the following command: ```docker run -it --rm jeremymiller/life-elixir mix credo --static```

To run the [Dialyzer](http://erlang.org/doc/man/dialyzer.html) static code analyzer, execute the following command: ```docker run -it --rm jeremymiller/life-elixir mix dialyzer```
*NOTE: The first time this command is run it may take a long time since it needs to create the PLT (see [here](https://github.com/jeremyjh/dialyxir#usage) for more information).*

### Test
To run the Portal tests, execute the following command: ```docker run -it --rm jeremymiller/life-elixir mix test```

### Run
To compile the Life application and run the *iex* REPL, execute the following command: ```docker run -it --rm jeremymiller/life-elixir```

## License
[MIT](https://github.com/jeremy-miller/life-elixir/blob/master/LICENSE)
