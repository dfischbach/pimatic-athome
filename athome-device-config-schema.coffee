# Defines a `node-convict` config-schema and exports it.
module.exports =

  AHSwitchFS20:
    id:
      doc: "The id of a device"
      format: String
      default: "atHomeId"
    name:
      doc: "The name of a device"
      format: String
      default: "atHomeName"
    houseid:
      doc: "The house code"
      format: String
      default: "0000"
    deviceid:
      doc: "The fs20 device id"
      format: String
      default: "00"

  AHSwitchElro:
    id:
      doc: "The id of a device"
      format: String
      default: "atHomeId"
    name:
      doc: "The name of a device"
      format: String
      default: "atHomeName"
    houseid:
      doc: "The house code"
      format: String
      default: "11111"
    deviceid:
      doc: "The elro device id"
      format: String
      default: "10000"

  AHSensorValue:
    id:
      doc: "The id of a device"
      format: String
      default: "atHomeId"
    name:
      doc: "The name of a device"
      format: String
      default: "atHomeName"
    sensorid:
      doc: "The id of a sensor"
      format: String
      default: "0"
    label:
      doc: "The display value of a value"
      format: String
      default: "Value"
    unit:
      doc: "The unit of a value"
      format: String
      default: ""
    scale:
      doc: "scale applied to the value"
      format: Number
      default: 1
    offset:
      doc: "offset applied to the value after scaling"
      format: Number
      default: 0
