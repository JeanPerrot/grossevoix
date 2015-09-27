# enqueue without interrupting
sonos = require './switch'

queue = []

# enqueue prevents enqueueing the same item.
enqueue = (url) ->
  return if playing is url
  return if (queue.indexOf(url) > -1)
  queue.push url
  play()

playing = null
play = ->
  return if playing
  url = queue.pop url
  return unless url
  playing = true
  sonos.play_now url, ->
    console.log "playing the next url in the queue"
    playing = false
    play()

module.exports =
  enqueue: enqueue
