EventEmitter = require('events').EventEmitter

# given a stream of events, decide if someone just came home (and emit an event)
# simply - if movement is detected within 10m of network join, emit an event for this join.
emitter = new EventEmitter()

within = (t1, t2, delta) ->
  d = Math.abs (t2 - t1)
  d < delta

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
  scanner.on 'joined', (id) ->
    latest_joins.push {id, time: new Date().getTime()}
    console.log 'joined'
    check()

  detector.on 'move', ->
    latest_move = {time: new Date().getTime()}
    console.log 'move'
    check()

module.exports = (scanner, detector) ->
  listen(scanner, detector)
  emitter
