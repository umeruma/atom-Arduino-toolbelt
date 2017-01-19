# ArduinoToolbeltView = require './arduino-toolbelt-view'
{CompositeDisposable} = require 'atom'
command = null

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
  modalPanel: null
  subscriptions: null
  command: null
  portListView: null

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
    # @arduinoToolbeltView = new ArduinoToolbeltView(state.arduinoToolbeltViewState)
    # @modalPanel = atom.workspace.addModalPanel(item: @arduinoToolbeltView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
      # 'arduino-toolbelt:toggle': => @toggle()
      'arduino-toolbelt:verify': => @verify()
      'arduino-toolbelt:upload': => @upload()
      'arduino-toolbelt:set-port': => @setPort()
      'arduino-toolbelt:reload-port': => @reloadPortList()
    
    @reloadPortList()
    
  deactivate: ->
    # @modalPanel.destroy()
    @subscriptions.dispose()
    # @arduinoToolbeltView.destroy()

  # serialize: ->
  #   arduinoToolbeltViewState: @arduinoToolbeltView.serialize()

  # toggle: ->
  #   console.log 'ArduinoToolbelt was toggled!'
  # 
  #   if @modalPanel.isVisible()
  #     @modalPanel.hide()
  #   else
  #     @modalPanel.show()
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

  setPort: ->
    if @portListView is null
      ListView = require('./arduino-port-list-view')
      @portListView = new ListView();
    ttyArray = @command.getPortList()
    @portListView.setItems(ttyArray)
    @portListView.show()
