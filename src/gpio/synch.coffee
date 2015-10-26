pins = require './pins'
emitter = require './events'

start = ->
  pins ({light}) ->
    emitter.on 'move', ->
      console.log 'led on'
      light true
    emitter.on 'still', ->
      console.log 'led off' 
      light false

# synch up the led with the motion detection pin
module.exports = start
