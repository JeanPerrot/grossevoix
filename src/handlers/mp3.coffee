out = require '../sound/out'

require 'shelljs/global'
request = require 'superagent'

module.exports =
  tts_url: (host, what) ->
    "http://#{host}:49160/mp3?msg=#{what}"

  getold: (req,res,next) ->
    msg = req.query.msg
    console.log 'got ' + msg
    res.set 'Content-Type', 'audio/mpeg'
    out.text_to_file msg, (err, name) ->
      console.log 'serving %s', name
      res.sendFile name
  get: (req,res,next) ->
    console.log 'request coming in!'
    res.set 'Content-Type', 'audio/mpeg'
    res.set 'Content-Length', '9195'
    res.set 'Accept-Ranges', 'bytes'
    url = 'http://media.tts-api.com/8aa5d56a065f13bd925ee28d95c509434716e66d.mp3'
    r  = request.get url
    r.pipe res
    r.end (err, audio) ->
      console.log audio
