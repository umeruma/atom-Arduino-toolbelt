# ArduinoToolbeltView = require './arduino-toolbelt-view'
{CompositeDisposable} = require 'atom'
child = require 'child_process'
exec = child.exec

module.exports = ArduinoToolbelt =
  arduinoToolbeltView: null
  modalPanel: null
  subscriptions: null

  config:
    arduinoPath:
      type: 'string',
      default: '/Applications/Arduino.app/Contents/MacOS/Arduino'
    

  activate: (state) ->
    # @arduinoToolbeltView = new ArduinoToolbeltView(state.arduinoToolbeltViewState)
    # @modalPanel = atom.workspace.addModalPanel(item: @arduinoToolbeltView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
      # 'arduino-toolbelt:toggle': => @toggle()
      'arduino-toolbelt:verify': => @verify()
      'arduino-toolbelt:upload': => @upload()

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
    # console.log 'verify arduino!'    
    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    filePath = file?.path

    arduinoPath = atom.config.get('arduino-toolbelt.arduinoPath')
    verifyCommand = arduinoPath + ' ' + filePath + ' ' + '--verify'

    exec verifyCommand, (err, stdout, stderr) ->
      # /* some process */
      if err is null
        atom.notifications.addSuccess('Done compiling.')
      else
        atom.notifications.addError(err, {detail: stderr, dismissable: true})
      # console.log stdout
      # console.log stderr

  upload: ->
    # console.log 'verify arduino!'
    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    filePath = file?.path
    # ttyArray = []
    exec 'ls /dev/tty.*', (err, stdout, stderr) ->
      # /* some process */
      if err is null
        console.log stdout.split('\n')
      # ttyArray = stdout.split('\n')

    arduinoPath = atom.config.get('arduino-toolbelt.arduinoPath')
    uploadCommand = arduinoPath + ' ' + filePath + ' ' + '--upload'
    exec uploadCommand, (err, stdout, stderr) ->
      # /* some process */
      # console.log stdout