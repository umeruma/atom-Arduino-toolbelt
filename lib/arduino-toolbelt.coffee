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

    # Register command
    @subscriptions.add atom.commands.add 'atom-workspace',
      'arduino-toolbelt:verify': => @verify()
      'arduino-toolbelt:upload': => @upload()
      'arduino-toolbelt:select-port': => @selectPort()
      'arduino-toolbelt:reload-port': => @reloadPortList()
    
    @reloadPortList()
    
  deactivate: ->
    @subscriptions.dispose()

  # serialize: ->
  #   arduinoToolbeltViewState: @arduinoToolbeltView.serialize()

  getCurFilePath: ->
    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    filePath = file?.path
    
  verify: ->
    @command.verify(@getCurFilePath())

  upload: ->
    @command.upload(@getCurFilePath())

  reloadPortList: ->
    @command.reloadPortList()

  selectPort: ->
    if @portSelectView is null
      ListView = require('./arduino-port-select-view')
      @portSelectView = new ListView();
    ttyArray = @command.getPortList()
    @portSelectView.setItems(ttyArray)
    @portSelectView.show()
