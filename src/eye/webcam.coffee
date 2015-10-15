cv = require 'opencv'
child = require 'child_process'
fs = require 'fs'
os = require 'os'

face = require './face'

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
    file = "#{webcam_files.directory}/#{filename}"
    fs.stat file, (err, stats) ->
      return if err?
      callback file if stats.isFile()

# upon new file, detect a face on it
process_snapshot = (file, callback) ->
  console.log 'processing', file
  face.detect_face file, (err, faces) ->
    if faces?.length
      console.log 'found faces: ', faces
    console.log err if err?
    # delete the file
    fs.unlink file, (err, res) ->
      console.log err if err
      callback err, res if callback


run = ->
  ffmpeg (camera) ->
    camera.stderr.on 'data', (data) ->
    process.on 'SIGINT', ->
      camera.kill 'SIGINT'
      process.exit()
      # console.log data.toString('utf-8')
  watch process_snapshot

run()

setTimeout (-> console.log 'hi'), 10000
