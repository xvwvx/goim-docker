FROM golang:1.16.5-alpine3.13 AS builder

RUN apk add --update \
    git \
  && rm -rf /var/cache/apk/*

WORKDIR /app
RUN git clone --branch master https://github.com/bilibili/discovery.git
WORKDIR /app/discovery/
RUN git reset --hard 1e12d5c0080ecd7ce97ab78076ef36dda8d56a1a

RUN go build -o dist/discovery cmd/discovery/main.go

FROM alpine:3.13.4
LABEL maintainer="jangsky215@gmail.com"
LABEL name="xvwvx/discovery"

WORKDIR /app
COPY --from=builder /app/discovery/dist/discovery /usr/local/bin/
COPY config/discovery.toml /app/

CMD discovery -conf discovery.toml