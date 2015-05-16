shell = require 'shelljs'


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
  tts_url: tts_url
  text_to_file: (what, callback) ->
    delegate = switch process.platform
      when 'darwin' then text_to_file_mac
      when 'linux' then text_to_file_pi
    delegate what, callback
