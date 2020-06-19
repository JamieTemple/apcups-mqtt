#!/bin/bash

service apcupsd stop
service apcupsd start

python3 apcups-mqtt.py