pimatic-athome
==============

This is a pimatic plugin which allows you to connect an Arduino compatible micro-controller over the serial port to the [pimatic home automation framework](http://pimatic.org).

In general you can use the plugin and micro-controller source code as a starting point for your specific needs.
It shows you, how to setup the communication between PI/Pimatic and the controller board using a serial connection,
  a separate USB to serial converter or the build in serial port with boards like the Arduino nano.



The source code for the micro-controller is available [here](https://github.com/dfischbach/pimatic-athome-arduino).

## Installation
To enable the AtHome plugin add this section to your config.json file.

```
...
{
  "plugin": "athome",
  "serialDeviceName": "/dev/ttyUSB0",
  "demo": true,
}
...
```

You may need to change the name of the serial device. This depends on your configuration.<br/>
On the Raspberry Pi it looks like '/dev/ttyUSB0'.<br/>
On my MacBook it is something like '/dev/tty.usbserial-A401159R' for an FTDI based USB to serial converter.

Use
```
sudo ls /dev

```
to display the available devices.


This is an example for the devices section in the config.json file.

```
...
  "devices": [
    {
      "class": "AHSwitchFS20",
      "id": "socketF1",
      "name": "Socket FS20",
      "houseid": "1234",
      "deviceid": "A8"
    },
    {
      "class": "AHSwitchElro",
      "id": "socketE1",
      "name": "Socket Elro",
      "houseid": "11011",
      "deviceid": "10000"
    },
    {
      "class": "AHRCSwitchElro",
      "id": "remoteswitch1",
      "name": "Remote Switch D",
      "houseid": "11011",
      "deviceid": "00010"
    },
    {
      "class": "AHSensorValue",
      "id": "valueWater",
      "name": "Water",
      "sensorid": "2",
      "label": "Water volume",
      "unit": "l"
    },
    {
      "class": "AHSensorValue",
      "id": "valueTemperature",
      "name": "Temperature Living Room",
      "sensorid": "10",
      "label": "Temperature",
      "unit": "°C"
    },
    {
      "id": "keypad",
      "name": "Keypad",
      "class": "AHKeypad",
      "buttons": [
        { "id": "0", "text": "0" },
        { "id": "1", "text": "1" },
        { "id": "2", "text": "2" },
        { "id": "3", "text": "3" },
        { "id": "4", "text": "4" },
        { "id": "5", "text": "5" },
        { "id": "6", "text": "6" },
        { "id": "7", "text": "7" },
        { "id": "8", "text": "8" },
        { "id": "9", "text": "9" },
        { "id": "A", "text": "A" },
        { "id": "B", "text": "B" },
        { "id": "C", "text": "C" },
        { "id": "D", "text": "D" },
        { "id": "#", "text": "#" },
        { "id": "*", "text": "*" }
      ]
    }
  ],

```