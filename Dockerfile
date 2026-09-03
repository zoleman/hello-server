FROM golang:1.25 AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .

RUN go build -o hello-server .

FROM debian:bookworm-slim

ARG APP_USER=appuser

WORKDIR /app

RUN useradd --system --uid 10001 --create-home ${APP_USER}

COPY --from=builder --chown=${APP_USER}:${APP_USER} /app/hello-server .

USER ${APP_USER}

ENV APP_PORT=8080

EXPOSE 8080

CMD ["./hello-server"]