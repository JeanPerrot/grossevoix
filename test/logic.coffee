logic = require '../src/welcome/logic'
EventEmitter = require('events').EventEmitter

describe 'event commingling', ->
  it 'emits events', (done) ->
    scanner = new EventEmitter()
    detector = new EventEmitter()
    event = logic(scanner, detector)
    event.on 'really_joined', (id) ->
      fail() unless id is 'device'
      done()
    scanner.emit 'joined', 'device'
    detector.emit 'move'
