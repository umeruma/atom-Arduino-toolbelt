{CompositeDisposable} = require 'atom'

# switch process.platform
#   when 'darwin'
#     binaryFilePathValue = 
#     break;
#   when 'win32'
#     binaryFilePathValue = '';
#     break;
#   else
#     binaryFilePathValue = '';

module.exports = ArduinoToolbelt =
  subscriptions: null
  command: null
  portSelectView: null

  config:
    binaryFilePath:
      type: 'string'
      default: '/Applications/Arduino.app/Contents/MacOS/Arduino'
      description: 'Executable file for building Arduino'
    devicePort:
      type: 'string'
      description: 'Arduino port for uploading'
      default: ''
    
  activate: (state) ->
    @command ?= require './arduino-command'
    @subscriptions = new CompositeDisposable
    
    @setInitialPort()

    # Register command
    @subscriptions.add atom.commands.add 'atom-workspace',
      'arduino-toolbelt:verify': => @verify()
      'arduino-toolbelt:upload': => @upload()
      'arduino-toolbelt:select-port': => @selectPort()
    
  deactivate: ->
    @subscriptions.dispose()

  # serialize: ->
  #   arduinoToolbeltViewState: @arduinoToolbeltView.serialize()

  setInitialPort: ->
    portArray = @command.getPortList()
    
    _Port = ''
    
    # search port looks like arduino's one
    for i in [0..portArray.length - 1]
      if portArray[i].indexOf('/dev/tty.usbserial') != -1
        _Port = portArray[i]
        break
    
    if _Port is ''
      _Port = portArray[0]
    
    if atom.config.get('arduino-toolbelt.devicePort') is ''
      atom.config.set('arduino-toolbelt.devicePort', _Port)
    
  getCurFilePath: ->
    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    filePath = file?.path
    
  verify: ->
    @command.verify(@getCurFilePath())

  upload: ->
    @command.upload(@getCurFilePath())

  selectPort: ->
    if @portSelectView is null
      ListView = require('./arduino-port-select-view')
      @portSelectView = new ListView();
    ttyArray = @command.getPortList()
    @portSelectView.setItems(ttyArray)
    @portSelectView.show()
