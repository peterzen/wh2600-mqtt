FROM golang:1.21 AS build

WORKDIR /build

# Copy go.mod and go.sum first for better caching
COPY go.mod go.sum ./
RUN go mod download || true

# Copy source code
COPY main.go ./

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o pwsmqttdispatcher main.go

# Final stage - minimal image
FROM alpine:latest

WORKDIR /app

# Copy the binary from build stage
COPY --from=build /build/pwsmqttdispatcher /app/pwsmqttdispatcher

# Run as non-root user
RUN adduser -D -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

ENTRYPOINT ["/app/pwsmqttdispatcher"]
