pins = require './pins'
emitter = require './events'

start = ->
  pins ({light}) ->
    emitter.on 'move', -> light true
    emitter.on 'still', -> light false

# synch up the led with the motion detection pin
module.exports = start
