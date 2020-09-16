while true ; do

  HASSIO_TOKEN=
  HASSIO_HOST=

  mem=$(free | grep ^Mem | tr -s ' ' | cut -f3 -d ' ')
  if [ "$?" -eq 0 ]; then
    curl -X POST -H "Authorization: Bearer $HASSIO_TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"state\": \"$mem\", \"attributes\": {\"unit_of_measurement\": \"Bytes\"}}" \
      http://$HASSIO_HOST:8123/api/states/sensor.hallway_tablet_used_memory
  fi

  swap=$(free | grep ^Swap | tr -s ' ' | cut -f3 -d ' ')
  if [ "$?" -eq 0 ]; then
    curl -X POST -H "Authorization: Bearer $HASSIO_TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"state\": \"$swap\", \"attributes\": {\"unit_of_measurement\": \"Bytes\"}}" \
      http://$HASSIO_HOST:8123/api/states/sensor.hallway_tablet_used_swap
  fi

  sleep 60

done
