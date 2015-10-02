EventEmitter = require('events').EventEmitter

# given a stream of events, decide if someone just came home (and emit an event)
# simple first shot - if movement is detected within 10m of network join, emit an event for this join.

# better logic --
# we want to emit after long absences
# a long absence is defined as the absence of a device for a long time, regardless of movement.
# we can reprocess the events to emit a 'return-from-absence' event when a device is seen after a long interval

within = (t1, t2, delta) ->
  d = Math.abs (t2 - t1)
  d < delta

reprocessor = (scanner) ->
  returned = new EventEmitter()
  seen = {}
  returned_interval = 4*60*60*1000
  scanner.on 'joined', (id) ->
    console.log 'processing joined for ', id
    now = new Date().getTime()
    previous = seen[id]
    console.log 'previous is', previous
    if previous and not within(previous, now,  returned_interval)
      returned.emit 'returned', id
    seen[id] = now
    console.log 'seen set to', seen[id]
  returned

emitter = new EventEmitter()

# keeps the join events from the last ten minutes
latest_joins = []
latest_move = {time:0}

check = ->
  return if latest_move.time == 0
  latest_joins = latest_joins.filter (join) ->
    within join.time, latest_move.time, 10 * 60 * 1000
  for join in latest_joins
    emitter.emit 'really_joined', join.id
  latest_joins = []
  latest_move.time = 0

# expect two event emitters: a scanner (joined) and a detector (move)
listen = (scanner, detector) ->
  scanner = reprocessor scanner

  scanner.on 'returned', (id) ->
    latest_joins.push {id, time: new Date().getTime()}
    console.log 'returned'
    check()

  detector.on 'move', ->
    latest_move = {time: new Date().getTime()}
    console.log 'move'
    check()

module.exports = (scanner, detector) ->
  listen(scanner, detector)
  emitter
