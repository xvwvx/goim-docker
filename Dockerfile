FROM golang:1.16.2-alpine3.13 AS builder

RUN apk add --update \
    git \
  && rm -rf /var/cache/apk/*

WORKDIR /app
RUN git clone --branch master https://github.com/Terry-Mao/goim.git
WORKDIR /app/goim/
RUN git reset --hard 24100d97e3cb50bfc81e6c9985109058fd55b579

RUN go build -o comet cmd/comet/main.go
RUN go build -o logic cmd/logic/main.go
RUN go build -o job cmd/job/main.go

FROM alpine:3.13.4
LABEL maintainer="jangsky215@gmail.com"
LABEL name="xvwvx/goim"

ENV PATH .:$PATH
ENV APP_NAME goim

WORKDIR /app
COPY --from=builder /app/goim/comet /app/goim/logic /app/goim/job /app/
COPY config/comet-example.toml config/job-example.toml config/logic-example.toml /app/

EXPOSE 8000
CMD ["sh"]