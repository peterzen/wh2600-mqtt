# Example: Running wh2600-mqtt Locally

This document provides examples for running the wh2600-mqtt tool in different ways.

## Option 1: Using Docker Compose (Recommended)

1. Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

2. Edit `.env` with your configuration:
```bash
nano .env  # or use your favorite editor
```

3. Start the service:
```bash
docker-compose up -d
```

4. Check logs:
```bash
docker-compose logs -f
```

## Option 2: Running the Binary Directly

1. Build the binary:
```bash
go build -o pwsmqttdispatcher main.go
```

2. Set environment variables and run:
```bash
export PWS_IP="192.168.1.100"
export MQTT_HOST="192.168.1.50"
export MQTT_PORT="1883"
export MQTT_USER="mqtt_user"
export MQTT_PASSWORD="your_password"
export MQTT_TOPIC="personal_weather_station"
export MQTT_CLIENT_ID="pwsmqttdispatcher"
export FETCH_INTERVAL="60"
export DEBUG_ENABLED="false"

./pwsmqttdispatcher
```

## Option 3: Using a .env File with Binary

1. Create a `.env` file (or copy from `.env.example`)

2. Load variables and run:
```bash
set -a
source .env
set +a
./pwsmqttdispatcher
```

## Testing with a Local MQTT Broker

If you want to test with a local Mosquitto MQTT broker:

```bash
# Start Mosquitto
docker run -d --name mosquitto -p 1883:1883 eclipse-mosquitto

# Subscribe to the topic to see published data
docker exec -it mosquitto mosquitto_sub -t "personal_weather_station" -v
```

## Troubleshooting

### Check if weather station is accessible
```bash
curl http://YOUR_PWS_IP/livedata.htm
```

### Enable debug mode
Set `DEBUG_ENABLED=true` in your `.env` file or environment variables.
