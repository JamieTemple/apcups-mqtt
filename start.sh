#!/bin/bash

service apcupsd restart

sleep 15

python3 apcups-mqtt.py