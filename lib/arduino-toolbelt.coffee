ArduinoToolbeltView = require './arduino-toolbelt-view'
{CompositeDisposable} = require 'atom'

module.exports = ArduinoToolbelt =
  arduinoToolbeltView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @arduinoToolbeltView = new ArduinoToolbeltView(state.arduinoToolbeltViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @arduinoToolbeltView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'arduino-toolbelt:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @arduinoToolbeltView.destroy()

  serialize: ->
    arduinoToolbeltViewState: @arduinoToolbeltView.serialize()

  toggle: ->
    console.log 'ArduinoToolbelt was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
