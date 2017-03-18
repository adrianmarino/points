FROM elixir:1.3

RUN apt-get update
RUN apt-get -y -q install mysql-client libmysqlclient-dev

COPY . /app
WORKDIR /app
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix compile
