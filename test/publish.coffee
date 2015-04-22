pub = require '../src/ip/publish'

describe 'ip publication', ->
  it 'reads properly from aws', (done)->
    pub.read (err, res)->
      done()
  it 'checks from public registry', (done)->
    pub.check (err, res)->
      done()
  it 'publishes to public registry', (done)->
    this.timeout 10000
    pub.publish (err, res)->
      done()
