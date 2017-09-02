FROM elixir:1.4
RUN mkdir -p /usr/src/app/apps/interface/assets
RUN mkdir -p /usr/src/app/apps/life_elixir
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update && \
    apt-get install -y --no-install-recommends inotify-tools nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /usr/src/app
COPY mix.exs .
COPY mix.lock .
COPY apps/interface/mix.exs apps/interface
COPY apps/life_elixir/mix.exs apps/life_elixir
RUN mix local.rebar --force
RUN mix local.hex --force
RUN mix deps.get
RUN mix deps.compile
RUN mix dialyzer --plt
WORKDIR /usr/src/app/apps/interface/assets
COPY apps/interface/assets/package.json .
RUN npm install
WORKDIR /usr/src/app
ENV MIX_ENV=dev
COPY . .
RUN mix compile
CMD ["mix", "phx.server"]
