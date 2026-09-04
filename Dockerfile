FROM golang:1.25@sha256:699337d620559a59b4a2bb298ad59611e535d2ee755a34cf2d2a98f37578dc80 AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .

RUN go build -o hello-server .

FROM debian:bookworm-slim@sha256:88200866dfff7ea7f5cbcb6ec7c8a701889efe6fe859fe64d6990e4b07ea4171

ARG APP_USER=appuser

WORKDIR /app

RUN useradd --system --uid 10001 --create-home ${APP_USER}

COPY --from=builder --chown=${APP_USER}:${APP_USER} /app/hello-server .

USER ${APP_USER}

ENV APP_PORT=8080

EXPOSE 8080

CMD ["./hello-server"]