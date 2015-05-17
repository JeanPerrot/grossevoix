shell = require 'shelljs'

http = require 'http'
fs = require 'fs'
request = require 'superagent'


google_to_file = (what, callback) ->
  params = encodeURIComponent(what)
  url ="http://translate.google.com/translate_tts?tl=en&q=#{params}"
  url= 'http://livingears.com/music/SceneNotHeard/091909/Do%20You%20Mind%20Kyla.mp3'
  url = 'http://media.tts-api.com/8aa5d56a065f13bd925ee28d95c509434716e66d.mp3'
  console.log url
  tmpname = "/tmp/some_file_#{new Date().getTime()}"
  tmpname = "/Users/jeannoelperrot/gears"

  file = fs.createWriteStream tmpname
  request.get(url)
    .end (err, res) ->
      console.log 'got something'
      res.pipe file
      file.end = ->
        callback null, "#{tmpname}.mp3"

tts_url = (what, callback)->
  url ="http://translate.google.com/translate_tts?tl=en&q=#{encodeURIComponent(what)}"
  url ="http://tts-api.com/tts.mp3?q=#{encodeURIComponent(what)}"
  callback null, url

text_to_file_mac = (what, callback) ->
  tmpname = "/tmp/some_file_#{new Date().getTime()}"
  cmd = "say \"#{what}\" -o #{tmpname}"
  console.log cmd
  shell.exec cmd, (err) ->
    shell.exec "lame -m m #{tmpname}.aiff #{tmpname}.mp3 ", (err) ->
      console.log err if err?
      callback null, "#{tmpname}.mp3"

text_to_file_pi = (what, callback) ->
  tmpname = "/tmp/some_file_#{new Date().getTime()}"
  cmd = "espeak -s 115 -ven+f3 -a 200 \"#{what}\" --stdout > #{tmpname}"
  console.log cmd
  shell.exec cmd, (err) ->
    shell.exec "lame -V2 #{tmpname} #{tmpname}.mp3 ", (err) ->
      console.log err if err?
      callback null, "#{tmpname}.mp3"

module.exports =
  google_to_file: google_to_file
  tts_url: tts_url
  text_to_file: (what, callback) ->
    delegate = switch process.platform
      when 'darwin' then text_to_file_mac
      when 'linux' then text_to_file_pi
    delegate what, callback
