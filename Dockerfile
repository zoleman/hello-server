FROM golang:1.25 AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .

RUN go build -o hello-server .

FROM debian:bookworm-slim

WORKDIR /app

COPY --from=builder /app/hello-server .

ENV APP_PORT=8080

EXPOSE 8080

CMD ["./hello-server"]