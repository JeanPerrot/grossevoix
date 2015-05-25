gpio = require 'pi-gpio'

sensor = 12
led = 7

init = (callback) ->
  gpio.open led, 'output', ->
    gpio.open sensor, 'input', ->
      gpio.write led, 0, ->
        callback()

move = (cb) ->
  gpio.read sensor, (err, res) ->
    return cb false if err?
    return cb (res is 1)

light = (val, cb) ->
  gpio.write led, ( if val then 1 else 0 ), cb

heartbeat = ->
  move (res) ->
    console.log res
    light res, ->

start =  ->
  init ->
    console.log 'init done'
    setInterval heartbeat, 500

module.exports = 
  init: init
  heartbeat: heartbeat
  start: start

