child = require 'child_process'
exec = child.exec
execSync = child.execSync

module.exports = ArduinoCommand =
  verify: (filePath, cb)->
    _cb = if cb then cb else ()->{}

    arduinoPath = atom.config.get('arduino-toolbelt.binaryFilePath')
    
    exec "#{arduinoPath} #{filePath} --verify", (err, stdout, stderr) ->
      if err is null
        atom.notifications.addSuccess('Done compiling.')
      else
        atom.notifications.addError('Compiling error', {detail: err + '\n' + stderr, dismissable: true})
      _cb()
        
  upload: (filePath) ->

    arduinoPath = atom.config.get('arduino-toolbelt.binaryFilePath')
    port = atom.config.get('arduino-toolbelt.devicePort')
    
    exec "#{arduinoPath} #{filePath} --upload --port #{port}", (err, stdout, stderr) ->
      if err is null
        atom.notifications.addSuccess('Done uploading.')
      else
        atom.notifications.addError('Uploading error', {detail: err + '\n' + stderr, dismissable: true})
      
  getPortList: ->
    execSync('ls /dev/tty.*', { encoding: 'utf8' })
      .split('\n')
      .filter((e)-> e isnt '')