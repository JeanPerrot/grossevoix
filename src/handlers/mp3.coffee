out = require '../sound/out'

require 'shelljs/global'

module.exports =
  tts_url: (host, what) ->
    "http://#{host}/mp3?msg=#{what}"

  get: (req,res,next) ->
    msg = req.query.msg
    console.log 'got ' + msg
    res.set 'Content-Type', 'audio/mpeg'
    out.text_to_file msg, (err, name) ->
      console.log 'serving %s', name
      res.sendFile name
