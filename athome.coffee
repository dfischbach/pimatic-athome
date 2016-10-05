
module.exports = (env) ->

  Promise = env.require 'bluebird'
  serialport = require 'serialport'
  SerialPort = serialport.SerialPort

  _ = env.require 'lodash'

  # the plugin class
  class AtHomePlugin extends env.plugins.Plugin

    @transport

    init: (app, @framework, @config) ->
      env.logger.info "atHome: init"

      serialName = @config.serialDeviceName
      env.logger.info("atHome: init with serial device #{serialName}@#{@config.baudrate}baud")

      @cmdReceivers = []
      @transport = new AHTransport serialName, @config.baudrate, @receiveCommandCallback

      deviceConfigDef = require("./athome-device-config-schema")

      deviceClasses = [
        AHSwitchFS20,
        AHSwitchElro,
        AHSensorValue,
        AHRCSwitchElro,
        AHKeypad
      ]

      for Cl in deviceClasses
        do (Cl) =>
          @framework.deviceManager.registerDeviceClass(Cl.name, {
            configDef: deviceConfigDef[Cl.name]
            createCallback: (deviceConfig) =>
              device = new Cl(deviceConfig)
              if Cl in [AHSwitchElro, AHRCSwitchElro, AHSensorValue, AHKeypad]
                @cmdReceivers.push device
              return device
          })

    removeCmdReceiver: (device) ->
      env.logger.info "removeCmdReceiver #{device}"

      index = @cmdReceivers.indexOf(device)
      if index > -1
        @cmdReceivers.splice(index, 1)

    sendCommand: (id, cmdString) ->
      @transport.sendCommand id, cmdString

    receiveCommandCallback: (cmdString) =>
      for cmdReceiver in @cmdReceivers
        handled = cmdReceiver.handleReceivedCmd cmdString
        break if handled

      if (!handled)
        env.logger.info "received unhandled command string: #{cmdString}"


  # AHTransport handles the communication with the arduino
  class AHTransport

    @serial

    constructor: (serialPortName, baudrate, @receiveCommandHandler) ->
      @cmdString = ""
      @isPortOpen = false
      @serial = new SerialPort serialPortName, {baudrate: baudrate}, false

      @serial.open (err) ->
        if ( err? )
          env.logger.error "open serialPort #{serialPortName} failed #{err}"
        else
          env.logger.info "open serialPort #{serialPortName}"


      @serial.on 'open', =>
        @isPortOpen = true

      @serial.on 'close', =>
        @isPortOpen = false

      @serial.on 'error', (err) =>
        env.logger.error "atHome: serial error #{err}"
        @isPortOpen = false

      @serial.on 'data', (data) =>
        env.logger.debug "atHome: serial data received #{data}"
        dataString = "#{data}"

        # remove carriage return
        dataString = dataString.replace(/[\r]/g, '')

        # line feed ?
        if dataString.indexOf('\n') != -1
          parts = dataString.split '\n'
          @cmdString = @cmdString + parts[0]
          @receiveCommandHandler @cmdString
          if ( parts.length > 0 )
            @cmdString = parts[1]
          else
            @cmdString = ''
        else
          @cmdString = @cmdString + dataString

    sendCommand: (id, cmdString) =>
      if @isPortOpen
        env.logger.debug "AtHomeTransport: #{id} sendCommand #{cmdString}"
        @serial.write(cmdString+'\n')
      else
        env.logger.error(
          "AtHomeTransport: serial port not open -> skipping command, trying to open serial port"
        )
        @serial.open (err) =>
          if ( err? )
            env.logger.error "open serialPort failed #{err}"
          else
            env.logger.info "serialPort opened"


  # AHSwitchFS20 controls FS20 devices
  class AHSwitchFS20 extends env.devices.PowerSwitch

    constructor: (@config) ->
      @id = @config.id
      @name = @config.name
      @houseid = @config.houseid
      @deviceid = @config.deviceid
      super()

    destroy: ->
      atHomePlugin.removeCmdReceiver this
      super()

    changeStateTo: (state) ->
      if @_state is state then return Promise.resolve true
      else return Promise.try( =>
        cmd = 'F '+@houseid+@deviceid
        atHomePlugin.sendCommand @id, (if state is on then cmd+'10' else cmd+'00')
        @_setState state
      )

  # AHSwitchElro controls ELRO power points
  class AHSwitchElro extends env.devices.PowerSwitch

    constructor: (@config) ->
      @id = @config.id
      @name = @config.name
      @houseid = @config.houseid
      @deviceid = @config.deviceid
      super()

    destroy: ->
      atHomePlugin.removeCmdReceiver this
      super()


    handleReceivedCmd: (command) ->
      params = command.split " "

      return false if (
        params.length < 4 or params[0] != "E" or params[1] != @houseid or params[2] != @deviceid
      )

      if ( params[3] == '1' )
        @changeStateTo on
      else
        @changeStateTo off

      return true


    changeStateTo: (state) ->
      if @_state is state then return Promise.resolve true
      else return Promise.try( =>
        cmd = 'E '+@houseid+' '+@deviceid
        atHomePlugin.sendCommand @id, (if state is on then cmd+' 1' else cmd+' 0')
        @_setState state
      )


  # AHRCSwitchElro is a switch which state can be changed be the ui or by an ELRO Remote control
  class AHRCSwitchElro extends env.devices.PowerSwitch

    constructor: (@config) ->
      @id = @config.id
      @name = @config.name
      @houseid = @config.houseid
      @deviceid = @config.deviceid
      @changeStateTo off
      super()

    destroy: ->
      atHomePlugin.removeCmdReceiver this
      super()

    changeStateTo: (state) ->
      if @_state is state then return Promise.resolve true
      else return Promise.try( =>
        @_setState state
      )

    handleReceivedCmd: (command) ->
      params = command.split " "

      return false if (
        params.length < 4 or params[0] != "E" or params[1] != @houseid or params[2] != @deviceid
      )
      if ( params[3] == '1' )
        @changeStateTo on
      else
        @changeStateTo off
      return true


  # AHSensorValue handles arduino delivered measure values like voltage, temperatue, ...
  class AHSensorValue extends env.devices.Sensor
    value: null

    getTemplateName: -> "device"

    constructor: (@config) ->
      @id = @config.id
      @name = @config.name
      @sensorid = @config.sensorid
      @scale = @config.scale
      @offset = @config.offset
      @value = 0

      @attributes =
        value:
          description: "the sensor value"
          type: "number"
          label: @config.label
          unit: @config.unit
      super()

    destroy: ->
      atHomePlugin.removeCmdReceiver this
      super()

    getValue: -> Promise.resolve(@value)

    handleReceivedCmd: (command) ->
      params = command.split " "

      return false if params.length < 4 or params[0] != "SV" or params[1] != @sensorid

      @value = parseFloat(params[3], 10)*@scale + @offset
      @emit "value", @value
      return true


  class AHKeypad extends env.devices.ButtonsDevice

    constructor: (@config, demo) ->
      super(@config)

    handleReceivedCmd: (command) ->
      params = command.split " "
      return false if params.length < 2 or params[0] != "K"
      key = params[1]
      #TODO: Check if button is on @config
      @emit "button", key
      return true


  atHomePlugin = new AtHomePlugin
  return atHomePlugin
