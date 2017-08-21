FROM elixir:1.4
ENV ELIXIR_VERSION=1.4.5
ENV OTP_RELEASE=19.3
ENV PLT_FILENAME=elixir-${ELIXIR_VERSION}_${OTP_RELEASE}.plt
ENV PLT_LOCATION=/usr/src/app/$PLT_FILENAME
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN wget -O $PLT_LOCATION https://raw.github.com/danielberkompas/travis_elixir_plts/master/$PLT_FILENAME
RUN apt-get update && apt-get install -y erlang-observer erlang-dialyzer
COPY mix.exs /usr/src/app
COPY mix.lock /usr/src/app
RUN mix local.rebar --force
RUN mix local.hex --force
RUN mix deps.get
COPY . /usr/src/app
CMD ["iex", "-S", "mix"]