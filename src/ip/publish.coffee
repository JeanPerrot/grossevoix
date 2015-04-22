# figure out the current IP address and publishes it to an outside registry

request = require 'request'
read_url = 'http://checkip.amazonaws.com/'
appId = 'DvAjuWljBB0RLhUjitZAodpTit1ePUhoWWhV97yq'
api_key = 'zFwmgWjoDBvzk3JlAI7pOHromzhmMFV4qPomymc0'

write_url = 'https://api.parse.com/1/classes/config'

async = require 'async'

options = (url)->
  url: url
  headers:
    'X-Parse-Application-Id': 'DvAjuWljBB0RLhUjitZAodpTit1ePUhoWWhV97yq'
    'X-Parse-REST-API-Key': 'zFwmgWjoDBvzk3JlAI7pOHromzhmMFV4qPomymc0'
    'Content-Type': 'application/json'


read = (callback)->
  request read_url, (err, response, body)->
    callback err, body

write = (data, callback)->
  req = options write_url
  req.body = JSON.stringify data
  request.post req, callback

check = (callback)->
  request options(write_url), (err, response, body)->
    callback err, JSON.parse body

del = (id, callback)->
  url = "#{write_url}/#{id}"
  req = options url
  request.del req, callback

delete_existing = (callback)->
  check (err, body)->
    async.eachSeries (entry.objectId for entry in body.results), del, callback
    # callback null

module.exports =
  read: read
  check: check
  write: write
  publish: (callback)->
    read (err, body)->
      delete_existing (err)->
        console.log err if err
        data =
          ip: body
        write data, callback
