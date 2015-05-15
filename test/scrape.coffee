{lease, clients} = require '../src/net/scrape'

describe 'scraping', ->
  it 'should work', (done) ->
    lease (err, res)->
      console.log res
      done()
  it 'will work', (done) ->
    clients (err, res) ->
      console.log res
      done()
