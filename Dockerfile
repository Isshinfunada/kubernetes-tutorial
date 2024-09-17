# ビルドステージ
FROM golang:1.16-alpine AS builder
WORKDIR /app
COPY go.mod .
COPY main.go .
RUN go mod download
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -a -installsuffix cgo -o app .

# 実行ステージ
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/app .
EXPOSE 8080
CMD ["./app"]