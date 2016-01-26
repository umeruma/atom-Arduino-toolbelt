child = require 'child_process'
exec = child.exec
execSync = child.execSync

module.exports =
  verify: (filePath, cb)->
    _cb = if cb then cb else ()->{}

    arduinoPath = atom.config.get('arduino-toolbelt.binaryFilePath')
    verifyCommand = arduinoPath + ' ' + filePath + ' ' + '--verify'
    console.log verifyCommand
    exec verifyCommand, (err, stdout, stderr) ->
      if err is null
        atom.notifications.addSuccess('Done compiling.')
      else
        atom.notifications.addError('Compiling error', {detail: err + '\n' + stderr, dismissable: true})
      _cb()
        
  upload: (filePath) ->

    arduinoPath = atom.config.get('arduino-toolbelt.binaryFilePath')
    port = atom.config.get('arduino-toolbelt.devicePort')
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
      atom.config.set('arduino-toolbelt.devicePort', _Port)
      
  getPortList: ->
    execSync('ls /dev/tty.*', { encoding: 'utf8' })
      .split('\n')
      .filter((e)-> e isnt '')