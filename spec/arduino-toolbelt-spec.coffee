ArduinoToolbelt = require '../lib/arduino-toolbelt'
path = require 'path'
fs = require 'fs'
child = require 'child_process'
exec = child.exec
execSync = child.execSync
        
# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "ArduinoToolbelt", ->
  [workspaceElement, arduinoPath, commandModule] = []

  beforeEach ->
    # workspaceElement = atom.views.getView(atom.workspace)
    ArduinoToolbelt.activate();
    arduinoPath = ArduinoToolbelt.config.binaryFilePath.default
    commandModule = require '../lib/arduino-command'
    
  describe "when the arduino-toolbelt was activated", ->
    it "auto detect arduino default cli path", ->
      fs.access(arduinoPath, fs.X_OK, (err) ->
        expect(if err then 'no access!' else 'can execute').toEqual('can execute')
      )
    
    it "verify empty arduino sketch", ->
      atom.config.set('arduino-toolbelt.binaryFilePath', arduinoPath)
      commandModule.verify('~/.atom/packages/arduino-toolbelt/spec/emptySketch/emptySketch.ino', -> 
        expect(atom.notifications.getNotifications().length).toBe(1)
        expect(atom.notifications.getNotifications()[0].getType()).toBe('success')
      )
      