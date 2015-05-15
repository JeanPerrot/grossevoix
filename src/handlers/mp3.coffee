out = require '../sound/out'

require 'shelljs/global'

module.exports =
  get: (req,res,next) ->
    out.text_to_file 'Dave, I understand you might be upset about this', (err, name) ->
      console.log 'serving %s', name
      res.sendFile name
