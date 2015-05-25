events = require('../net/events')
out = require '../sound/out'
sonos = require '../sonos/switch'

known =
  '10:68:3F:49:D2:8E': 'Jean'

messages =
  'Jean': -> sonos.play_now 'http://www.miss-music.com/music/pomp_loop.mp3', ->

events.on 'joined', (mac) ->
  known_device =  known[mac]
  msg = messages[known_device]
  if msg
    msg()
