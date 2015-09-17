gpio = require 'pi-gpio'

sensor = 12
led = 7

safe_open = (pin, mode, callback) ->
  gpio.close pin, ->
    gpio.open pin, mode, callback

# initialize pins
initialized = false
init = (callback) ->
  callback() unless initialized
  initialized = true
  safe_open led, 'output', ->
    safe_open sensor, 'input', ->
      gpio.write led, 0, ->
        callback()

# are we currently detecting movement?
moving = (cb) ->
  gpio.read sensor, (err, res) ->
    return cb false if err?
    return cb (res is 1)

# turn led on or off
light = (val, cb) ->
  gpio.write led, ( if val then 1 else 0 ), cb or ->

module.exports = (callback) ->
  init -> callback {moving,light}
