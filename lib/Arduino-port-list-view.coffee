{SelectListView} = require 'atom-space-pen-views'

module.exports =
class ArduinoPortListView extends SelectListView
  # constructor: (serializedState) ->
  #   # Create root element
  #   @element = document.createElement('div')
  #   @element.classList.add('Arduino-toolbelt')
  # 
  #   # Create message element
  #   message = document.createElement('div')
  #   message.textContent = "The ArduinoToolbelt package is Alive! It's ALIVE!"
  #   message.classList.add('message')
  #   @element.appendChild(message)

  initialize: ->
    super
    @addClass('arduino-port-list overlay from-top')

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  show: ->
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()
    @focusFilterEditor()
  
  viewForItem: (item) ->
    "<li>#{item}</li>"

  confirmed: (item) ->
    console.log("#{item} was selected")
    @panel.hide()

  cancelled: ->
    console.log("This view was cancelled")
    @panel.hide()
