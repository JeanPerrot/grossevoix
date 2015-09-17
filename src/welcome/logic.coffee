EventEmitter = require('events').EventEmitter

# given a stream of events, decide if someone just came home (and emit an event)
scan = require '../net/events'
move = require '../gpio/events'

# simply - if movement is detected within 10m of network join, be happy.
emitter = new EventEmitter()

within = (t1, t2, delta) ->
  d = Math.abs (t2 - t1)
  d < delta

latest_joins = []
latest_move = {time:0}

check = ->
  return if latest_move.time == 0
  latest_joins = latest_joins.filter (join) ->
    within join.time, latest_move.time, 10 * 60 * 1000
  for join in latest_joins
    emitter.emit 'really_joined', join.id

scan.on 'joined', (id) ->
  latest_joins.push {id, time: new Date().getTime()}
  console.log 'joined'
  check()

move.on 'move', ->
  latest_move = {time: new Date().getTime()}
  console.log 'move'
  check()

module.exports = emitter
