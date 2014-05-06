# Defines a `node-convict` config-schema and exports it.
module.exports =
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
    default: "2525"
  deviceid:
    doc: "The fs20 device id"
    format: String
    default: "00"