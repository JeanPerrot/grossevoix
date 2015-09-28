scanner = require '../net/events'
detector = require '../gpio/events'

events = require('./logic')(scanner, detector)
out = require '../sound/out'
sonos = require '../sonos/switch'
sonos_queue = require '../sonos/queue'

known =
  '10:68:3F:49:D2:8E': 'Jean'
  '88:C9:D0:A9:7E:63': 'Greta'
  '64:76:BA:E8:0F:D1': 'Aiden'
  'D8:D1:CB:16:DA:2E': 'Kadeg'
  '14:10:9F:1E:DA:82': 'Kadeg'

messages =
  'Jean': -> sonos_queue.enqueue 'http://www.miss-music.com/music/pomp_loop.mp3'
  'Greta': -> sonos_queue.enqueue 'http://archive.org/download/ClairDeLunedebussy/2009-03-30-clairdelune_64kb.mp3'
  'Kadeg': -> sonos_queue.enqueue 'http://cs1.mp3.pm/download/46116001/Nms3aVMxYTZIQmFyWEU3aHg4RkFOa3JZMG0wNThzNHlwdEpGWHJ2ZE5tSWZkZHVlYVgxS0pNRXBiMzE2VTUvZnZTRjdPQ3FJN0dhMExOdWRiTUJSMXBDV2Z5MEdCOExMN0dsSzd4VWNSV0d4LysvaFJzaGtrZ0FEMTR0dTlvWis/Attack_On_Titan_-_Opening_Theme_full_(mp3.pm).mp3'
  'Aiden': -> sonos_queue.enqueue 'http://mp3li.net/en/download.php?d=EYTo0OntzOjE6ImgiO3M6MzI6IjBiODI2OGM1YmZjOTkxMGYwYWYyYmUwZDY4YTRiODhmIjtzOjE6InQiO3M6Mzg6IkhlbnJ5IE1hbmNpbmkgLSBUaGUgUGluayBQYW50aGVyIFRoZW1lIjtzOjE6ImMiO2k6MTQ0MzQwMjA3NTtzOjI6ImlwIjtzOjEyOiI2Ny41LjE5My4xODIiO30='

events.on 'really_joined', (mac) ->
  console.log 'looking for message for ', mac
  known_device =  known[mac]
  console.log 'device unknown ', mac unless known_device
  msg = messages[known_device]
  console.log 'message not found' unless msg
  console.log "playing message for #{known_device}"  if msg
  msg() if msg
