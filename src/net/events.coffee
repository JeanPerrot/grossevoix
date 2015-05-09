# emit event as when a device joins the network. passes the mac address.
scan = require './scan'
EventEmitter = require('events').EventEmitter
{extend} = require 'underscore'

diff = (pre, post) ->
  added = []
  removed = []
  for item in pre
    removed.push item if item not in post
  for item in post
    added.push item if item not in pre
  console.log {added, removed}
  {added, removed}

emitter = new EventEmitter()

set_interval = (timeout, f) ->
  setInterval f, timeout

scan_interval = 30000
started = false

start = ->
  started = true
  last = []
  set_interval scan_interval, ->
    console.log 'starting'
    scan.scan (err, res) ->
      next = (item.mac for item in res)
      {removed, added} = diff last, next
      if last isnt []
        for device in added
          emitter.emit 'joined', device
      last = next

emitter.start = ->
  start() unless started

emitter.on 'joined', (device) ->
  console.log 'JOINED: %j', device

module.exports = emitter
