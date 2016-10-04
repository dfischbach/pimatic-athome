module.exports = {
  title: "pimatic-athome config"
  type: "object"
  properties:
    serialDeviceName:
      doc: "The name of the serial device to use"
      type: "string"
      default: "/dev/tty"
    baudrate:
      doc: "The baudrate to use for serial communication"
      type: "number"
      default: 57600
}
