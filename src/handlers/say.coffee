out = require '../sound/out'
mp3 = require './mp3'
sw = require '../sonos/switch'
discovery = require '../net/discovery'

ip = discovery().en0

module.exports =
  get: (req,res,next) ->
    res.send 'ok'

  post: (req,res,next)->
    msg = req.query.msg
    url = mp3.tts_url ip, msg
    console.log url
    out.tts_url msg, (err, url) ->
      console.log url
      # url = 'http://livingears.com/music/SceneNotHeard/091909/Do%20You%20Mind%20Kyla.mp3'
      # url = 'http://translate.google.   com/translate_tts?tl=en&q=hello%2C%20world'
      # url = 'http://media.tts-api.com/8aa5d56a065f13bd925ee28d95c509434716e66d.mp3'
      # url = 'http://192.168.1.174:49160/mp3'
      sw.play_now url, (err) ->
        console.log 'CALLBACK'
        if err
          console.log err
          res.status(500).end()
        else
          res.send('said').end()
