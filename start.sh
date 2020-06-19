#!/bin/bash

service apcupsd stop
service apcupsd start

apcaccess

python3 apcups-mqtt.py