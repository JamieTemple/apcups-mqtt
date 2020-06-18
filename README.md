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

## Things file

```
Thing mqtt:topic:broker:ups-1           "MQTT - Office UPS"    (mqtt:broker:broker) {
    Channels:
        Type string     : driver        "Driver"                        [ stateTopic="ups-01/driver"]
        Type string     : header        "Header"                        [ stateTopic="ups-01/apc"]
        Type datetime   : date          "Last seen"                     [ stateTopic="ups-01/date" ]
        Type string     : hostname      "Host name"                     [ stateTopic="ups-01/hostname"]
        Type string     : name          "Name"                          [ stateTopic="ups-01/upsname"]
        Type string     : version       "Version"                       [ stateTopic="ups-01/version"]
        Type string     : cable         "Cable"                         [ stateTopic="ups-01/cable"]
        Type string     : model         "Model"                         [ stateTopic="ups-01/model"]
        Type string     : mode          "Mode"                          [ stateTopic="ups-01/upsmode"]
        Type datetime   : starttime     "Start time"                    [ stateTopic="ups-01/starttime" ]
        Type string     : status        "Status"                        [ stateTopic="ups-01/status"]
        Type number     : linev         "Current line voltage"          [ stateTopic="ups-01/linev" ]
        Type number     : loadpct       "Battery load"                  [ stateTopic="ups-01/loadpct",  min=0, max=100 ]
        Type number     : bcharge       "Battery charge"                [ stateTopic="ups-01/bcharge",  min=0, max=100 ]
        Type number     : timeleft      "Remaining battery time"        [ stateTopic="ups-01/timeleft" ]
        Type number     : mbattchg      "Battery minimum charge"        [ stateTopic="ups-01/mbattchg", min=0, max=100 ]
        Type number     : mintimel      "Minimum battery time left"     [ stateTopic="ups-01/mintimel" ]
        Type number     : maxtime       "Maximum time on batteries"     [ stateTopic="ups-01/maxtime" ]
        Type number     : maxlinev      "Maximum live voltage"          [ stateTopic="ups-01/maxlinev" ]
        Type number     : minlinev      "Minimum live voltage"          [ stateTopic="ups-01/minlinev" ]
        Type number     : outputv       "UPS Output voltage"            [ stateTopic="ups-01/outputv" ]
        Type string     : sensitivity   "Sensitivity"                   [ stateTopic="ups-01/sense"]
        Type number     : dwake         "Wake delay"                    [ stateTopic="ups-01/dwake" ]
        Type number     : dshutd        "Shutdown delay"                [ stateTopic="ups-01/dshutd" ]
        Type number     : dlowbatt      "Low battery delay"             [ stateTopic="ups-01/dlowbatt" ]
        Type number     : lotrans       "Low voltage threshold"         [ stateTopic="ups-01/lotrans" ]
        Type number     : hitrans       "High voltage threshold"        [ stateTopic="ups-01/hitrans" ]
        Type number     : retpct        "Required power-on percent"     [ stateTopic="ups-01/retpct" ]
        Type number     : itemp         "Internal UPS temperature"      [ stateTopic="ups-01/itemp" ]
        Type number     : alarmdel      "Alarm delay period"            [ stateTopic="ups-01/alarmdel" ]
        Type number     : battv         "Battery voltage"               [ stateTopic="ups-01/battv" ]
        Type number     : linefreq      "Line frequency"                [ stateTopic="ups-01/linefreq" ]
        Type string     : lastxfre      "Last transfer reason"          [ stateTopic="ups-01/lastxfer" ]
        Type number     : numxfers      "Number of transfers"           [ stateTopic="ups-01/numxfers" ]
        Type datetime   : xonbatt       "Last transfer to batteries"    [ stateTopic="ups-01/xonbatt" ]
        Type number     : tonbatt       "Current time on batteries"     [ stateTopic="ups-01/tonbatt" ]
        Type number     : cumonbatt     "Cumulative time on batteries"  [ stateTopic="ups-01/cumonbatt" ]
        Type datetime   : xoffbatt      "Last transfer from batteries"  [ stateTopic="ups-01/xonbatt" ]
        Type string     : selftest      "Last self-test results"        [ stateTopic="ups-01/selftest" ]
        Type number     : stesti        "Time between self tests"       [ stateTopic="ups-01/stesti" ]
        Type string     : statflag      "Status flag"                   [ stateTopic="ups-01/statflag" ]
        Type string     : dipsw         "DIP Switch Settings"           [ stateTopic="ups-01/dipsw" ]
        Type string     : reg1          "Fault register 1 value"        [ stateTopic="ups-01/reg1" ]
        Type string     : reg2          "Fault register 2 value"        [ stateTopic="ups-01/reg2" ]
        Type string     : reg3          "Fault register 3 value"        [ stateTopic="ups-01/reg3" ]
        Type datetime   : mandate       "Manufaturing date"             [ stateTopic="ups-01/mandate" ]
        Type string     : serialno      "Serial number"                 [ stateTopic="ups-01/serialno" ]
        Type datetime   : batterydate   "Battery date"                  [ stateTopic="ups-01/battdate" ]
        Type number     : nomoutv       "Nominal output voltage"        [ stateTopic="ups-01/nomoutv" ]
        Type number     : nominv        "Nominal input voltage"         [ stateTopic="ups-01/nominv" ]
        Type number     : nombattv      "Nominal battery voltage"       [ stateTopic="ups-01/nombattv" ]
        Type number     : nompower      "Maximum available power"       [ stateTopic="ups-01/nompower" ]
        Type number     : humidity      "UPS Humidity"                  [ stateTopic="ups-01/humidity" ]
        Type number     : ambtemp       "UPS Ambient temperature"       [ stateTopic="ups-01/ambtemp" ]
        Type number     : extbatts      "External batteries"            [ stateTopic="ups-01/extbatts" ]
        Type number     : badbatts      "Number of bad battery packs"   [ stateTopic="ups-01/badbatts" ]
        Type string     : firmware      "Firmware version"              [ stateTopic="ups-01/firmware"]
        Type string     : apcmodel      "APC Model ID code"             [ stateTopic="ups-01/apcmodel"]
        Type datetime   : endapc        "End APC"                       [ stateTopic="ups-01/end apc" ]
}
```

## Items file

```
String      Ups_01_Firmware     "UPS 1 Firmware version"                                    (gUPS_01)   { channel="mqtt:topic:broker:ups-1:firmware" }
String      Ups_01_Mode         "UPS 1 Mode"                                                (gUPS_01)   { channel="mqtt:topic:broker:ups-1:mode" }
String      Ups_01_Status       "UPS 1 Status"                                              (gUPS_01)   { channel="mqtt:topic:broker:ups-1:status" }
String      Ups_01_Sensitivity  "UPS 1 Sensitivity"                                         (gUPS_01)   { channel="mqtt:topic:broker:ups-1:sensitivity" }
String      Ups_01_Name         "UPS 1 Name"                                                (gUPS_01)   { channel="mqtt:topic:broker:ups-1:name" }
String      Ups_01_Driver       "UPS 1 Driver"                                              (gUPS_01)   { channel="mqtt:topic:broker:ups-1:driver" }
String      Ups_01_Model        "UPS 1 Model"                                               (gUPS_01)   { channel="mqtt:topic:broker:ups-1:model" }
DateTime    Ups_01_LastSeen     "UPS 1 Last Seen [%1$tT %1$td-%1$tm-%1$tY]"                 (gUPS_01)   { channel="mqtt:topic:broker:ups-1:date" }
DateTime    Ups_01_StartTime    "UPS 1 Start Time [%1$tT %1$td-%1$tm-%1$tY]"                (gUPS_01)   { channel="mqtt:topic:broker:ups-1:starttime" }
DateTime    Ups_01_BattDate     "UPS 1 Batteries last replaced [%1$tT %1$td-%1$tm-%1$tY]"   (gUPS_01)   { channel="mqtt:topic:broker:ups-1:batterydate" }
Number      Ups_01_Charge       "UPS 1 Battery Charge [%.2f %%]"                            (gUPS_01)   { channel="mqtt:topic:broker:ups-1:bcharge" }
Number      Ups_01_Load         "UPS 1 Battery Load [%.2f %%]"                              (gUPS_01)   { channel="mqtt:topic:broker:ups-1:loadpct" }
Number      Ups_01_MinCharge    "UPS 1 Battery Minimum Charge before shutdown [%.2f %%]"    (gUPS_01)   { channel="mqtt:topic:broker:ups-1:mbattchg" }
Number      Ups_01_LineVoltage  "UPS 1 Line voltage [%.2f V]"                               (gUPS_01)   { channel="mqtt:topic:broker:ups-1:linev" }
Number      Ups_01_TimeLeft     "UPS 1 Available time on batteries"                         (gUPS_01)   { channel="mqtt:topic:broker:ups-1:timeleft" }
Number      Ups_01_MaxLineV     "UPS 1 Maximum line voltage [%.2f V]"                       (gUPS_01)   { channel="mqtt:topic:broker:ups-1:maxlinev" }
Number      Ups_01_MinLineV     "UPS 1 Minimum line voltage [%.2f V]"                       (gUPS_01)   { channel="mqtt:topic:broker:ups-1:minlinev" }
Number      Ups_01_HighTrans    "UPS 1 High line transtion voltage [%.2f V]"                (gUPS_01)   { channel="mqtt:topic:broker:ups-1:hitrans" }
Number      Ups_01_LowTrans     "UPS 1 Low line transition voltage [%.2f V]"                (gUPS_01)   { channel="mqtt:topic:broker:ups-1:lotrans" }
Number      Ups_01_Power        "UPS 1 Battery power [%.2f W]"                              (gUPS_01)   { channel="mqtt:topic:broker:ups-1:nompower" }
```

# References
https://www.cyberciti.biz/faq/debian-ubuntu-centos-rhel-install-apcups/
https://www.cyberciti.biz/faq/debian-ubuntu-centos-rhel-install-apcups/

# Contributing
TODO: ... 
