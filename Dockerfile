FROM elixir:1.4
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN apt-get update && \
    apt-get install -y --no-install-recommends inotify-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
COPY mix.exs /usr/src/app
COPY mix.lock /usr/src/app
RUN mix local.rebar --force
RUN mix local.hex --force
RUN mix deps.get
RUN mix deps.compile
RUN mix dialyzer --plt
COPY . /usr/src/app
RUN MIX_ENV=dev mix compile
CMD ["iex", "-S", "mix"]
