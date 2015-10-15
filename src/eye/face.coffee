cv = require 'opencv'

# calls back with err, faces
detect_face = (file, callback) ->
  time = new Date().getTime()
  cv.readImage file, (err, im) ->
    return callback err if err?
    console.log im
    return callback 'image has no size' if (im.width() < 1 || im.height() < 1)
    im.detectObject cv.FACE_CASCADE, {}, (err, faces) ->
      elapsed = new Date().getTime() - time
      console.log "took #{elapsed}ms"
      callback err, faces

module.exports = {detect_face}
