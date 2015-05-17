disc = require '../src/net/discovery'

describe 'host ip discovery', ->
  it 'finds your ip', ->
    ip = disc()
    console.log ip
