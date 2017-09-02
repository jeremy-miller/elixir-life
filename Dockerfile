FROM elixir:1.4
RUN mkdir -p /usr/src/app/apps/interface
RUN mkdir -p /usr/src/app/apps/life_elixir
WORKDIR /usr/src/app
RUN apt-get update && \
    apt-get install -y --no-install-recommends inotify-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
COPY mix.exs /usr/src/app
COPY mix.lock /usr/src/app
COPY apps/interface/mix.exs /usr/src/app/apps/interface
COPY apps/life_elixir/mix.exs /usr/src/app/apps/life_elixir
RUN mix local.rebar --force
RUN mix local.hex --force
RUN mix deps.get
RUN mix deps.compile
RUN mix dialyzer --plt
COPY . /usr/src/app
RUN mix compile
CMD ["mix", "phx.server"]
