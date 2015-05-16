out = require '../sound/out'
mp3 = require './mp3'
sw = require '../sonos/switch'


module.exports =
  get: (req,res,next) ->
    res.send 'ok'

  post: (req,res,next)->
    msg = req.query.msg
    url = mp3.tts_url req.headers.host, msg
    out.tts_url msg, (err, url) ->
      console.log url
      url = 'http://livingears.com/music/SceneNotHeard/091909/Do%20You%20Mind%20Kyla.mp3'
      sw.play_now url, (err) ->
        if err
          res.status(500).end()
        else
          res.send('said').end()
