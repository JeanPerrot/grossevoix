cv = require 'opencv'
child = require 'child_process'
fs = require 'fs'
os = require 'os'

webcam_files =
  ffmpeg_pattern: "#{os.tmpdir()}webcam/stream-%06d.jpeg"
  directory: "#{os.tmpdir()}webcam"
  pattern: "stream-"

ffmpeg = (callback) ->
  # child.spawn 'ffmpeg', ['-f', 'avfoundation', '-r', '30', '-f','mpeg', '-i', "'0'", 'pipe:1'], {stdio: 'pipe'}
  fs.mkdir webcam_files.directory, ->
    cmd = "ffmpeg -f avfoundation -r 30 -i 0 -r 1 #{webcam_files.ffmpeg_pattern}"
    console.log 'executing', cmd
    process = child.exec cmd, ->
    callback process


# calls back with new files
watch = (callback) ->
  fs.watch webcam_files.directory, (event, filename) ->
    # deletes spawn
    # change is emitted upon creation of a new file
    # rename is emitted sometimes instead of change
    console.log "filesystem event:", event
    fs.stat "#{webcam_files.directory}/#{filename}", (err, stats) ->
      return if err?
      callback filename if stats.isFile()

# calls back with err, faces
detect_face = (file, callback) ->
  cv.readImage "#{webcam_files.directory}/#{file}", (err, im) ->
    return callback err if err?
    console.log im
    return callback 'image has no size' if (im.width() < 1 || im.height() < 1)
    im.detectObject cv.FACE_CASCADE, {}, callback


# upon new file, detect a face on it
process_snapshot = (file, callback) ->
  console.log 'processing', file
  detect_face file, (err, faces) ->
    if faces?.length
      console.log 'found faces: ', faces
    console.log err if err?
    # delete the file
    fs.unlink "#{webcam_files.directory}/#{file}", (err, res) ->
      console.log err if err
      callback err, res if callback


run = ->
  ffmpeg (camera) ->
    camera.stderr.on 'data', (data) ->
      # console.log data.toString('utf-8')
  watch process_snapshot

run()

setTimeout (-> console.log 'hi'), 10000
