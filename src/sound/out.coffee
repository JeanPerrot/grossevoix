sys = require 'sys'
exec = require('child_process').exec

module.exports =
  say: (what, callback)->
    exec "say #{what}", (err, stdin, stderr)->
      callback err
