#!/bin/bash

service apcupsd restart

# Pause ... to allow the apcups daemon to come online nicely...
sleep 15

python3 apcups-mqtt.py