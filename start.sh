#!/bin/bash

service apcupsd restart

python3 apcups-mqtt.py