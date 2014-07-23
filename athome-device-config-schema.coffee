module.exports = {
  title: "athome device config schemas"
  AHSwitchFS20: {
    title: "AHSwitchFS20 config options"
    type: "object"
    properties:
      id:
        description: "The id of a device"
        type: "string"
        default: "atHomeId"
      name:
        description: "The name of a device"
        type: "string"
        default: "atHomeName"
      houseid:
        description: "The house code"
        type: "string"
        default: "0000"
      deviceid:
        description: "The fs20 device id"
        type: "string"
        default: "00"
  }
  AHSwitchElro: {
    title: "AHSwitchElro config options"
    type: "object"
    properties:
      id:
        description: "The id of a device"
        type: "string"
        default: "atHomeId"
      name:
        description: "The name of a device"
        type: "string"
        default: "atHomeName"
      houseid:
        description: "The house code"
        type: "string"
        default: "11111"
      deviceid:
        description: "The elro device id"
        type: "string"
        default: "10000"
  }
  AHRCSwitchElro: {
    title: "AHRCSwitchElro config options"
    type: "object"
    properties:
      id:
        description: "The id of a device"
        type: "string"
        default: "atHomeId"
      name:
        description: "The name of a device"
        type: "string"
        default: "atHomeName"
      houseid:
        description: "The house code"
        type: "string"
        default: "11111"
      deviceid:
        description: "The elro device id"
        type: "string"
        default: "10000"
  }
  AHSensorValue: {
    title: "AHSensorValue config options"
    type: "object"
    properties:
      id:
        description: "The id of a device"
        type: "string"
        default: "atHomeId"
      name:
        description: "The name of a device"
        type: "string"
        default: "atHomeName"
      sensorid:
        description: "The id of a sensor"
        type: "string"
        default: "0"
      label:
        description: "The display value of a value"
        type: "string"
        default: "Value"
      unit:
        description: "The unit of a value"
        type: "string"
        default: ""
      scale:
        description: "scale applied to the value"
        type: "number"
        default: 1
      offset:
        description: "offset applied to the value after scaling"
        type: "number"
        default: 0
  }
}