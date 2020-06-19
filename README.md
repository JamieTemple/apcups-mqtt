# Introduction 
A simple MQTT client for publishing APC UPS status changes.

If you are looking for instructions on setting-up and using `apcups-mqtt` then head over to the [wiki](https://github.com/JamieTemple/apcups-mqtt/wiki) for more help.

# Getting Started

## Platform support

This script has been tested on Ubuntu Linux. It should probably run fine on any other distros.

Although completely untested, there is a fair chance that most of it might work on Windows as well.

## Dependencies

This script is of absolutely no use whatsoever unless you've installed `apcupsd` (and have a connected UPS!).

This script is designed to run on Python 3. It'll probably work on Python 2 as well, but attempt at your own risk ;)

This script depends on the following Pyton libraries:

```
configparser
paho-mqtt
```

## Configuration
Before you begin, you need to modify the configuration file:

```
[mqtt]
broker_address  = <your MQTT broker address>
broker_username = <your MQTT broker user name>
broker_password = <your MQTT broker password>
client_name     = <name this service will expose itself to the MQTT broker as>
root_topic      = <root topic for publishing messages under>
```

## Running

```
pip3 install -r requirements.txt
python3 apcups-mqtt.py
```

See the [wiki](https://github.com/JamieTemple/apcups-mqtt/wiki) for instructions on running as a service, or in a container.


# References
https://www.cyberciti.biz/faq/debian-ubuntu-centos-rhel-install-apcups/

http://www.apcupsd.org/manual/manual.html#basic-user-s-guide

# Contributing
TODO: ... 
