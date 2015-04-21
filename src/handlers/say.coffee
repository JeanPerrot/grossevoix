out = require '../sound/out'

module.exports =
  get: (req,res,next) ->
    res.send 'ok'

  post: (req,res,next)->
    msg = req.query.msg
    out.say msg, (err)->
      if err
        res.status(500).end()
      else
        res.send 'ok'
