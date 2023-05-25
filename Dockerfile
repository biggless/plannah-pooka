# syntax=docker/dockerfile:1
FROM elixir:1.14.4-alpine
WORKDIR /src
EXPOSE 4000
RUN apk --no-cache --update add inotify-tools && \
    mix local.hex --force && \
    mix local.rebar --force
CMD ["mix", "phx.server"]
