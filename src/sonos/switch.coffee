# methods for switching sonos mode
sonos = require 'sonos'
{extend} = require 'underscore'

device_details = (device, model, callback)->
  data = {ip: device.host, port: device.port, model: model}
  device.getZoneAttrs (err, attrs)->
    extend data, attrs unless err
    device.getZoneInfo (err, info)->
      extend data, info unless err
      device.getTopology (err, info)->
        info.zones.forEach (group)->
          if (group.location == 'http://' + data.ip + ':' + data.port + '/xml/device_description.xml')
            extend data, group
            callback null, data


find_zone5 = (callback)->
  found_zf5 = false
  error = false
  setTimeout =>
    error = true
    callback 'timeout' unless found_zf5
  , 5000

  sonos.search (device, name)=>
    found_zf5 = true
    callback null, device if name is 'ZPS5' and error is false


find_coordinator = (callback)->
  found = false
  error = false
  setTimeout =>
    error = true
    callback 'timeout' unless found
  , 10000

  sonos.search (device, name)=>
    device_details device, name, (err, details)->
      if details.coordinator == 'true' and details.name != 'BRIDGE'
        found = true
        callback null, device

# TODO get to the previously played track?
play_now = (url, callback)->
  console.log 'playing %s', url
  find_coordinator (err, dev)->
    return callback 'not found' unless dev?
    dev.getCurrentState (err, current)->
      dev.currentTrack (err, track)->
        # use that to find in queue? better to get the queue index with a better API
        console.log track
        dev.play url, (err)->
          return callback err if err?
          interval = setInterval ->
            dev.getCurrentState (err, state)->
              if state != 'playing'
                clearInterval interval
                dev.selectQueue (err)->
                  if current == 'playing'
                    dev.play callback
                  else
                    callback()
          , 1000


module.exports =
  play_now: play_now
