gpio = require 'pi-gpio'

sensor = 12
led = 7
eyes_led = 8
network_led = 10

safe_open = (pin, mode, callback) ->
  console.log 'opening', pin, mode
  gpio.close pin, ->
    gpio.open pin, mode, callback

# initialize pins
initialized = false
init = (callback) ->
  console.log 'pins initialized:', initialized
  return callback() if initialized
  initialized = true
  safe_open led, 'output', ->
    gpio.write led, 0, ->
      safe_open eyes_led, 'output', ->
        gpio.write eyes_led, 0, ->
          safe_open network_led, 'output', ->
            gpio.write network_led, 0, ->
              safe_open sensor, 'input', ->
                callback()

moving = (cb) ->
  gpio.read sensor, (err, res) ->
    val = 'move' if res is 1
    val = 'still' if res is 0
    cb err, val


# turn led on or off
set_led = (led, val, cb) ->
  console.log "setting #{led} to #{val}"
  gpio.write led, ( if val then 1 else 0 ), cb or ->

light = (val, cb) -> set_led led, val, cb
eyes = (val, cb) -> set_led eyes_led, val, cb
network = (val, vb) -> set_led network_led, val, cb

module.exports = (callback) ->
  init -> callback {moving, light, eyes, network}
