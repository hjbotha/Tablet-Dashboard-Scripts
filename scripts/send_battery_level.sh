while true ; do

  HASSIO_TOKEN=
  HASSIO_HOST=
  
  batterylevel=$(dumpsys battery | grep level | cut -d ' ' -f 4)
  echo $batterylevel


  if [ "$?" -eq 0 ]; then
    curl -X POST -H "Authorization: Bearer $HASSIO_TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"state\": \"$batterylevel\", \"attributes\": {\"unit_of_measurement\": \"%\",\"friendly_name\": \"Hallway Tablet Battery Level\"}}" \
      http://$HASSIO_HOST:8123/api/states/sensor.hallway_tablet_battery_level
  fi

  sleep 300

done

