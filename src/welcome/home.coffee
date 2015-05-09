events = require('../net/events')
out = require '../sound/out'

known =
  '10:68:3F:49:D2:8E': 'Jean'

messages =
  'Jean': 'Welcome home, John. I hope you had a pleasant outing'

events.on 'joined', (mac) ->
  known_device =  known[mac]
  msg = messages[known_device]
  if msg
    out.say msg, ->
      console.log 'said: %s', msg
