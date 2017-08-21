FROM elixir:1.4
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN apt-get update && apt-get install -y erlang-observer erlang-dialyzer
COPY mix.exs /usr/src/app
COPY mix.lock /usr/src/app
RUN mix local.rebar --force
RUN mix local.hex --force
RUN mix deps.get
COPY . /usr/src/app
CMD ["iex", "-S", "mix"]