sys = require 'sys'
sw = require '../sonos/switch'

shell = require 'shelljs'


tts_url = (what, callback)->
  url ="http://translate.google.com/translate_tts?tl=en&q=#{encodeURIComponent(what)}"
  callback null, url

text_to_file_mac = (what, callback) ->
  tmpname = "/tmp/some_file_#{new Date().getTime()}"

  shell.exec "say \"#{what}\" -o #{tmpname}", (err) ->
    shell.exec "lame -m m #{tmpname}.aiff #{tmpname}.mp3 ", (err) ->
      console.log err if err?
      callback null, "#{tmpname}.mp3"

text_to_file_pi = (what, callback) ->
  tmpname = "/tmp/some_file_#{new Date().getTime()}"
  cmd = "espeak -ven+f3 -k5 -s150 \"#{what}\" --stdout > #{tmpname}"
  console.log cmd
  shell.exec cmd, (err) ->
    console.log err if err?
    callback null, tmpname


module.exports =
  text_to_file: (what, callback) ->
    delegate = switch process.platform
      when 'darwin' then text_to_file_mac
      when 'linux' then text_to_file_pi
    delegate what, callback

  say: (what, callback)->
    tts_url what, (err, url)->
      sw.play_now url, callback
