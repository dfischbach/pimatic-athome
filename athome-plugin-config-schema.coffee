module.exports = {
  title: "athome config"
  type: "object"
  properties:
    serialDeviceName:
      description: "The name of the serial device to use"
      type: "string"
      default: "/dev/tty"
    baudrate:
      description: "The baudrate to use for serial communication"
      type: "integer"
      default: 57600
    demo:
      description: "if true, no connection with serial device"
      type: "boolean"
      default: true
}
