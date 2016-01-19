# ArduinoToolbeltView = require './Arduino-toolbelt-view'
{CompositeDisposable} = require 'atom'
child = require 'child_process'
exec = child.exec
execSync = child.execSync

switch process.platform
  when 'darwin'
    binaryFilePath = '/Applications/Arduino.app/Contents/MacOS/Arduino'
    break;
  when 'win32'
    binaryFilePath = '';
    break;
  else
    binaryFilePath = '';

module.exports = ArduinoToolbelt =
  arduinoToolbeltView: null
  modalPanel: null
  subscriptions: null

  config:
    binaryFilePath:
      type: 'string'
      default: binaryFilePath
      description: 'Executable file for building Arduino'
    devicePort:
      type: 'string'
      description: 'Arduino port for uploading'
      default: ''
    

  activate: (state) ->
    # @arduinoToolbeltView = new ArduinoToolbeltView(state.arduinoToolbeltViewState)
    # @modalPanel = atom.workspace.addModalPanel(item: @arduinoToolbeltView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
      # 'Arduino-toolbelt:toggle': => @toggle()
      'Arduino-toolbelt:verify': => @verify()
      'Arduino-toolbelt:upload': => @upload()
      'Arduino-toolbelt:reload-port': => @reloadPort()
      # 'Arduino-toolbelt:list-port': => @listPort()
    @reloadPort()

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
  
  verify: ->
    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    filePath = file?.path

    arduinoPath = atom.config.get('Arduino-toolbelt.binaryFilePath')
    verifyCommand = arduinoPath + ' ' + filePath + ' ' + '--verify'

    exec verifyCommand, (err, stdout, stderr) ->
      if err is null
        atom.notifications.addSuccess('Done compiling.')
      else
        atom.notifications.addError('Compiling error', {detail: err + '\n' + stderr, dismissable: true})

  upload: ->
    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    filePath = file?.path

    arduinoPath = atom.config.get('Arduino-toolbelt.binaryFilePath')
    port = atom.config.get('Arduino-toolbelt.devicePort')
    uploadCommand = arduinoPath + ' ' + filePath + ' ' + '--upload --port ' + port
    exec uploadCommand, (err, stdout, stderr) ->
      if err is null
        atom.notifications.addSuccess('Done uploading.')
      else
        atom.notifications.addError('Uploading error', {detail: err + '\n' + stderr, dismissable: true})

  reloadPort: ->
    exec 'ls /dev/tty.*', (err, stdout, stderr) ->
      ttyArray = stdout.split('\n').filter((e)-> e isnt "")
      _Port = ''
      for i in [0..ttyArray.length - 1]
        if ttyArray[i].indexOf('/dev/tty.usbserial') != -1
          _Port = ttyArray[i]
          break
      
      if _Port is ''
        _Port = ttyArray[0]
      atom.config.set('Arduino-toolbelt.devicePort', _Port)

  # listPort: ->
  #   ArduinoPortListView = require('./arduino-port-list-view');
  #   portListView = new ArduinoPortListView();

    # ttyArray = execSync('ls /dev/tty.*').split('\n').filter((e)-> e isnt "")
    
    # portListView.setItems(ttyArray)
    # portListView.show();
