events = require './logic'
out = require '../sound/out'
sonos = require '../sonos/switch'

known =
  '10:68:3F:49:D2:8E': 'Jean'

messages =
  'Jean': -> sonos.play_now 'http://www.miss-music.com/music/pomp_loop.mp3', ->

events.on 'really_joined', (mac) ->
  console.log 'looking for message for ', mac
  known_device =  known[mac]
  console.log 'device unknown ', mac unless known_device
  msg = messages[known_device]
  console.log 'message not found' unless msg
  console.log 'playing message' if msg
  msg() if msg
