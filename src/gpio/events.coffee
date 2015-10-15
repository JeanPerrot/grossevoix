EventEmitter = require('events').EventEmitter
pins = require './pins'
gpio = require 'pi-gpio'

set_interval = (interval, f) -> setInterval f, interval

emitter = new EventEmitter()
started = false

to_events = (probe) ->
  value = 0
  set_interval 100, ->
    probe (err, res) ->
      console.log 'probe result', res
      return if err?
      return if res is value
      value = res
      emitter.emit value

start = ->
  started = true
  pins ({moving}) ->
    to_events moving


emitter.start = -> start() unless started

emitter.on 'move', ->
  console.log 'movement detected'

emitter.on 'still', ->
  console.log 'detector still'

module.exports = emitter
