#!/bin/bash

service apcupsd restart

apcaccess

#python3 apcups-mqtt.py
tail -F /var/log/apcupsd.events