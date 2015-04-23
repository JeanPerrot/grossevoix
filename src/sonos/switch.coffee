# methods for switching sonos mode
sonos = require 'sonos'

find_zone5 = (callback)->
  found_zf5 = false
  error = false
  setTimeout =>
    error = true
    callback 'timeout' unless found_zf5
  , 5000

  sonos.search (device, name)=>
    found_zf5 = true
    callback null, device if name is 'ZPS5' and error is false

play = (dev,callback)->
  dev.play 'http://tts-api.com/tts.mp3?q=Hello%20children%2C%20good%20morning', callback

module.exports =
  find: find_zone5
  play: play
