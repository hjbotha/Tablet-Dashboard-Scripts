#! /bin/bash

HASSIO_TOKEN=
HASSIO_HOST=

while true; do
    entity_json=$(
        curl -X GET -H "Authorization: Bearer $HASSIO_TOKEN" \
        -H "Content-Type: application/json" \
        http://$HASSIO_HOST:8123/api/states/light.hallway_tablet_screen 2>/dev/null
    )

    if [ $? -eq 0 ]; then
        if dumpsys display | grep mScreenState=ON > /dev/null 2>&1 ; then
            current_state=on
        else
            current_state=off
        fi
        current_brightness=$(cat /sys/devices/platform/leds-mt65xx/leds/lcd-backlight/brightness)

        echo Current state: $current_state
        if [ "$current_state" == "on" ]; then
            echo Current brightness: $current_brightness
        fi

        desired_state=$(echo $entity_json | sed 's/.*"state": "\(.*\)".*/\1/')

        echo Desired state: $desired_state

        if [ "$desired_state" == "on" ]; then
            desired_brightness=$(echo $entity_json | sed 's/.*"brightness": \([0-9]*\).*/\1/')
            echo Desired brightness: $desired_brightness
        fi

        if [ "$current_state" == "on" ] && [ "$desired_state" == "off" ]; then
            input keyevent KEYCODE_POWER
        elif [ "$current_state" == "off" ] && [ "$desired_state" == "on" ]; then
            echo $desired_brightness >/sys/devices/platform/leds-mt65xx/leds/lcd-backlight/brightness
            input keyevent KEYCODE_WAKEUP
        elif [ "$current_state" == "on" ] && [ "$desired_state" == "on" ] && [ $current_brightness -ne $desired_brightness ]; then
            echo $desired_brightness >/sys/devices/platform/leds-mt65xx/leds/lcd-backlight/brightness
        fi

        # will check every 30 seconds
        sleep 30
    else
        # not a graceful exit, retry in 5 seconds
        echo Failed to connect to Home Assistant. Check status and HASSIO_TOKEN.
        sleep 5
    fi
done

