# Introduction 
A simple MQTT client for publishing APC UPS status changes.

# Getting Started
This section is very rough and ready right now - just getting everything in place - please be patient :)


## Install and configure apcupsd

```
apt-get install apcupsd
```

For a much better description of setting up apcupsd, see: https://www.cyberciti.biz/faq/debian-ubuntu-centos-rhel-install-apcups/


## Clone this repo:

```
git clone https://github.com/JamieTemple/apcups-mqtt.git
```


## Install python dependencies

```
pip3 install -r requirements.txt
```

## Configuring the script

Now you need to modify the configuration file with your settings:

```
[mqtt]
broker_address  = <your MQTT broker address>
broker_username = <your MQTT broker user name>
broker_password = <your MQTT broker password>
client_name     = <name this service will expose itself to the MQTT broker as>
root_topic      = <root topic for publishing messages under>
```

## Running the script from a shell:
I strongly suggest that you set this script up to run as a service (detailed below).
However, if you just want to see if you've got things set up correctly, you can simply run the script directly from the shell, using:

```
python3 apcups-mqtt.py
```

## Running the script as a Linux service:

Create a service configuration file:
```
sudo nano /lib/systemd/system/apcups-mqtt.service
```

... you will need to tweak the values for your system, but the service configuration file should look similar to this:

```
[Unit]
Description=apcups-mqtt

[Service]
Type=simple
WorkingDirectory=/opt/acpups-mqtt
User=root
ExecStart=python3 apcups-mqtt.py

[Install]
WantedBy=multi-user.target
```
Note the working directory needs to be wherever you have copied the files from this repo to.

The `User` will likely be `root` or `pi` if you're running this on a RPi.
The important thing here however is that you must have run the 'Install python dependencies' step earlier in the appropriate context for the user that the service will run under. e.g. if the service is running as `root`, then you will need to have installed the dependencies using `sudo pip3 install -r requirements.txt`.

Once you have created the service, you just need to spin things up, and we're away!

```
sudo systemctl daemon-reload
sudo systemctl enable apcups-mqtt
sudo systemctl start apcups-mqtt
```

... After this, your service should be posting messages to your MQTT broker, ready for consumption by OpenHAB.

To check things are running smoothly, you can type:

```
systemctl status apcups-mqtt
```

This should show something like:

```
apcpsu-mqtt.service - apcpsu-mqtt
     Loaded: loaded (/lib/systemd/system/apcpsu-mqtt.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2020-06-17 22:58:07 BST; 19h ago
   Main PID: 3849965 (python3)
      Tasks: 2 (limit: 19008)
     Memory: 13.7M
     CGroup: /system.slice/apcpsu-mqtt.service
             └─3849965 /usr/bin/python3 apcpsu-mqtt.py

Jun 18 18:19:17 scooby python3[3849965]: INFO:root:Updating param end apc from 2020-06-18T18:19:07+0100 to 2020-06-18T18:19:17+0100
Jun 18 18:19:27 scooby python3[3849965]: INFO:root:Updating param date from 2020-06-18T18:19:17+0100 to 2020-06-18T18:19:26+0100
Jun 18 18:19:27 scooby python3[3849965]: INFO:root:Updating param linev from 232.0 to 234.0
Jun 18 18:19:27 scooby python3[3849965]: INFO:root:Updating param battv from 27.2 to 27.1
Jun 18 18:19:27 scooby python3[3849965]: INFO:root:Updating param end apc from 2020-06-18T18:19:17+0100 to 2020-06-18T18:19:27+0100
Jun 18 18:19:37 scooby python3[3849965]: INFO:root:Updating param date from 2020-06-18T18:19:26+0100 to 2020-06-18T18:19:37+0100
Jun 18 18:19:37 scooby python3[3849965]: INFO:root:Updating param linev from 234.0 to 232.0
Jun 18 18:19:37 scooby python3[3849965]: INFO:root:Updating param timeleft from 8.3 to 8.1
Jun 18 18:19:37 scooby python3[3849965]: INFO:root:Updating param battv from 27.1 to 27.2
Jun 18 18:19:37 scooby python3[3849965]: INFO:root:Updating param end apc from 2020-06-18T18:19:27+0100 to 2020-06-18T18:19:37+0100
```

# OpenHAB setup
TODO: ...


# References
https://www.cyberciti.biz/faq/debian-ubuntu-centos-rhel-install-apcups/

https://www.cyberciti.biz/faq/debian-ubuntu-centos-rhel-install-apcups/

# Contributing
TODO: ... 
