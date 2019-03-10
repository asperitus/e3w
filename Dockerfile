FROM golang:1.11.5-alpine3.9 as backend

RUN apk add --no-cache git

ADD . /app
WORKDIR /app

RUN CGO_ENABLED=0 go build

FROM node:8 as frontend

ADD static /app
WORKDIR /app
RUN npm --registry=https://registry.npm.taobao.org \
--cache=$HOME/.npm/.cache/cnpm \
--disturl=https://npm.taobao.org/mirrors/node \
--userconfig=$HOME/.cnpmrc install && npm run publish

FROM alpine:latest

COPY --from=backend /app/e3w /app/
COPY --from=frontend /app/dist /app/static/dist
COPY conf/config.default.ini /app/conf/

EXPOSE 8080
WORKDIR /app

CMD ["/app/e3w"]
