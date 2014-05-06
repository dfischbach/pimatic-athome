# #my-plugin configuration options

# Declare your config option for your plugin here. 

# Defines a `node-convict` config-schema and exports it.
module.exports =
  serialDeviceName:
    doc: "The name of the serial device to use"
    format: String
    default: "/dev/tty"
  demo:
    doc: "if true, no connection with serial device"
    format: Boolean
    default: "true"
