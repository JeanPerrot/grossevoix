# emit event as when a device joins the network. passes the mac address.
scan = require './scan'
EventEmitter = require('events').EventEmitter
NodeCache = require 'node-cache'

event_disappearance_period = 300# in s
cache = new NodeCache { stdTTL: event_disappearance_period }

diff = (post) ->
  added = []
  for item in post
    added.push item unless cache.get item
    cache.set item, item if item
  added

emitter = new EventEmitter()

set_interval = (timeout, f) ->
  setInterval f, timeout

scan_interval = 30000
started = false

start = ->
  started = true
  set_interval scan_interval, ->
    console.log 'starting'
    scan.scan (err, res) ->
      next = (item.mac for item in res)
      added = diff next
      for device in added
        emitter.emit 'joined', device
      last = next

emitter.start = ->
  start() unless started

emitter.on 'joined', (device) ->
  console.log 'JOINED: %j', device

module.exports = emitter
