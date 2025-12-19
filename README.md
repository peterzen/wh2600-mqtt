# wh2600-mqtt

A lightweight Docker-based tool that retrieves live weather data from WH2600/Froggit personal weather stations and publishes it to MQTT.

## Supported Weather Stations

- Renkforce WH2600
- Froggit units (compatible models)

## Features

- Fetches live weather data from your personal weather station via HTTP
- Publishes data to MQTT broker in JSON format
- Configurable polling interval
- Calculates derived values (heat index, wind chill, dew point)
- Docker-based for easy deployment

## Quick Start

1. Clone this repository:
```bash
git clone https://github.com/peterzen/wh2600-mqtt.git
cd wh2600-mqtt
```

2. Edit `docker-compose.yml` and configure your environment variables:
   - `PWS_IP`: IP address of your weather station (e.g., `192.168.1.100`)
   - `MQTT_HOST`: IP address or hostname of your MQTT broker
   - `MQTT_PORT`: MQTT broker port (default: `1883`)
   - `MQTT_USER`: MQTT username
   - `MQTT_PASSWORD`: MQTT password
   - `MQTT_TOPIC`: MQTT topic to publish to (default: `personal_weather_station`)
   - `MQTT_CLIENT_ID`: MQTT client identifier (default: `pwsmqttdispatcher`)
   - `FETCH_INTERVAL`: Polling interval in seconds (default: `60`)
   - `DEBUG_ENABLED`: Enable debug logging (default: `false`)

3. Start the service:
```bash
docker-compose up -d
```

4. View logs:
```bash
docker-compose logs -f
```

## Configuration

### Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `PWS_IP` | IP address of the weather station | Yes | - |
| `MQTT_HOST` | MQTT broker hostname/IP | Yes | - |
| `MQTT_PORT` | MQTT broker port | No | `1883` |
| `MQTT_USER` | MQTT username | Yes | - |
| `MQTT_PASSWORD` | MQTT password | Yes | - |
| `MQTT_TOPIC` | Topic to publish weather data | No | `personal_weather_station` |
| `MQTT_CLIENT_ID` | MQTT client identifier | No | `pwsmqttdispatcher` |
| `FETCH_INTERVAL` | Polling interval in seconds | Yes | - |
| `DEBUG_ENABLED` | Enable debug logging | No | `false` |

### Using Environment File

You can also use a `.env` file instead of hardcoding values in docker-compose.yml:

```bash
# .env file
PWS_IP=192.168.1.100
MQTT_HOST=192.168.1.50
MQTT_PORT=1883
MQTT_USER=mqtt_user
MQTT_PASSWORD=your_password_here
MQTT_TOPIC=personal_weather_station
MQTT_CLIENT_ID=pwsmqttdispatcher
FETCH_INTERVAL=60
DEBUG_ENABLED=false
```

Then update docker-compose.yml to use `env_file`:
```yaml
services:
  wh2600-mqtt:
    env_file:
      - .env
```

## Weather Data Format

The tool publishes weather data in JSON format with the following fields:

```json
{
  "receiverTime": "12:34 19/12/2025",
  "receiverTimestamp": 1703000000,
  "temperatureIndoor": 22.5,
  "humidityIndoor": 45.0,
  "pressureAbsolute": 1013.2,
  "pressureRelative": 1015.4,
  "temperature": 15.3,
  "humidity": 65.0,
  "dewPoint": 8.5,
  "windDir": 225.0,
  "windDirCardinal": "SW ↗️",
  "windSpeed": 12.5,
  "windGust": 18.2,
  "windChill": 13.1,
  "solarRadiation": 456.0,
  "uv": 2.5,
  "uvi": 3.0,
  "precipHourlyRate": 0.0,
  "precipDaily": 2.3,
  "precipWeekly": 12.5,
  "precipMonthly": 45.6,
  "precipYearly": 678.9,
  "heatIndex": 16.2,
  "indoorSensorId": "0xad",
  "outdoorSensorId": "0x0e",
  "indoorSensorBattery": "Normal",
  "outdoorSensorBattery": "Normal"
}
```

## Development

### Building

```bash
docker-compose build
```

### Running Tests

```bash
go test -v ./...
```

### Building Locally

```bash
go build -o pwsmqttdispatcher main.go
```

## Troubleshooting

1. **Cannot connect to weather station**: Ensure the `PWS_IP` is correct and the weather station is accessible on your network.

2. **Cannot connect to MQTT broker**: Verify MQTT broker credentials and ensure the broker is running and accessible.

3. **No data published**: Enable debug mode by setting `DEBUG_ENABLED=true` to see detailed logs.

## License

See [LICENSE](LICENSE) file for details.

## Credits

Based on the [hass-pws-mqtt-addon](https://github.com/peterzen/hass-pws-mqtt-addon) project, stripped of Home Assistant specific dependencies for standalone Docker deployment.