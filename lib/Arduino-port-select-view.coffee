{SelectListView} = require 'atom-space-pen-views'

module.exports =
class ArduinoPortSelectView extends SelectListView
  initialize: ->
    super
    @addClass('arduino-port-select')

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  show: ->
    @panel ?= atom.workspace.addModalPanel item: this
    @panel.show()
    @focusFilterEditor()
  
  viewForItem: (item) ->
    "<li>#{item}</li>"

  confirmed: (item) ->
    #console.log "#{item} was selected"
    atom.config.set 'arduino-toolbelt.devicePort', item
    @panel.hide()

  cancelled: ->
    #console.log "Port selecting view was cancelled"
    @panel.hide()