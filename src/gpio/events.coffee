EventEmitter = require('events').EventEmitter
pins = require './pins'


set_interval = (interval, f) -> setInterval f, interval

emitter = new EventEmitter()
started = false

start = ->
  started = true
  pins ({moving}) ->
    set_interval 100, ->
      moving (res) ->
        if res
          emitter.emit 'move'
        else
          emitter.emit 'still'

emitter.start = -> start() unless started

module.exports = emitter
