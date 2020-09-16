while true ; do

  HASSIO_TOKEN=
  HASSIO_HOST=
  
  rawbatterytemperature=$(dumpsys battery | grep temperature | cut -d ' ' -f 4)
  realbatterytemperature=$((rawbatterytemperature / 10))

  if [ "$?" -eq 0 ]; then
    curl -X POST -H "Authorization: Bearer $HASSIO_TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"state\": \"$realbatterytemperature\", \"attributes\": {\"unit_of_measurement\": \"°C\",\"friendly_name\": \"Hallway Tablet Battery Temperature\"}}" \
      http://$HASSIO_HOST:8123/api/states/sensor.hallway_tablet_battery_temperature
  fi

  sleep 60

done

