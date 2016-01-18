module.exports =
class ArduinoToolbeltView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('arduino-toolbelt')

    # Create message element
    message = document.createElement('div')
    message.textContent = "The ArduinoToolbelt package is Alive! It's ALIVE!"
    message.classList.add('message')
    @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
