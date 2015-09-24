scanner = require '../net/events'
detector = require '../gpio/events'

events = require('./logic')(scanner, detector)
out = require '../sound/out'
sonos = require '../sonos/switch'
sonos_queue = require '../sonos/queue'

known =
  '10:68:3F:49:D2:8E': 'Jean'
  '88:C9:D0:A9:7E:63': 'Greta'

messages =
  'Jean': -> sonos_queue.enqueue 'http://www.miss-music.com/music/pomp_loop.mp3'
  'Greta': -> sonos_queue.enqueue 'http://archive.org/download/ClairDeLunedebussy/2009-03-30-clairdelune_64kb.mp3'

events.on 'really_joined', (mac) ->
  console.log 'looking for message for ', mac
  known_device =  known[mac]
  console.log 'device unknown ', mac unless known_device
  msg = messages[known_device]
  console.log 'message not found' unless msg
  console.log "playing message for #{known_device}"  if msg
  msg() if msg
