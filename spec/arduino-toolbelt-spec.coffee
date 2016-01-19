ArduinoToolbelt = require '../lib/arduino-toolbelt'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "ArduinoToolbelt", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('arduino-toolbelt')

  describe "when the arduino-toolbelt:toggle event is triggered", ->
    it "hides and shows the modal panel", ->

      expect("There is no testcode now. Sorry.").toExist()