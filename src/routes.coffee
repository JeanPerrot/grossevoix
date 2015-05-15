handlers = require './handlers'
module.exports =

  apply: (router) ->
    router.custom 'api'
    router.api 'say', '/say', handlers.say
    router.api 'mp3', '/mp3', handlers.mp3
