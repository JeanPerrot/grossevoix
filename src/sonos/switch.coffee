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
        if not info
          console.log 'zones not found'
          return callback 'zones not found'
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
      if not details
        console.log "details not found for #{device}"
        return callback "details not found for #{device}"
      if details.coordinator == 'true' and details.name != 'BRIDGE'
        found = true
        callback null, device

# TODO get to the previously played track?
play_now = (url, callback)->
  console.log 'playing %s', url
  find_coordinator (err, dev)->
    return callback 'not found' unless dev?
    dev.getCurrentState (err, current)->
      return callback err if err?
      dev.currentTrack (err, track)->
        return callback err if err?
        # use that to find in queue? better to get the queue index with a better API
        console.log track
        dev.play url, (play_err) ->
          interval = setInterval ->
            dev.getCurrentState (reset_err, state)->
              console.log state
              if state is 'stopped' and interval isnt null
                clearInterval interval
                interval = null
                dev.selectQueue (queue_err)->
                  if current == 'playing'
                    dev.play (err, res) ->
                      callback play_err or reset_err or queue_err or err
                  else
                    callback play_err or reset_err or queue_err
          , 1000


module.exports =
  play_now: play_now
