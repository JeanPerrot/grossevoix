sys = require 'sys'
exec = require('child_process').exec
sw = require '../sonos/switch'

tts_url = (what, callback)->
  url ="http://translate.google.com/translate_tts?tl=en&q=#{encodeURIComponent(what)}"
  callback null, url
  

module.exports =
  say: (what, callback)->
    tts_url what, (err, url)->
      sw.play_now url, callback
