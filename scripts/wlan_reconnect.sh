#! /bin/bash

testip=192.168.14.1

while true; do
    if ping -c 1 -W 1 $testip; then
        sleep 1
    else
        killall -HUP wpa_supplicant
        sleep 60
    fi
done
