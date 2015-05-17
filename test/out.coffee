out = require '../src/sound/out'

describe 'making noises', ->
  @timeout 30000
  it 'should download from google', (done) ->
    out.google_to_file "hello, world, I wonder what is up with you today", (err, res) ->
      done()
