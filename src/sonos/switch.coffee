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

play_now = (url, callback)->
  find_coordinator (err, dev)->
    dev.queue url, 1, (err, playing)->
      dev.stop (err)->
        dev.play callback


module.exports =
  play_now: play_now
