# sudo nmap -sP 192.168.1.0/24
nmap = require 'node-libnmap'

cidr = (callback) ->
  nmap.nmap 'discover', (err, report) ->
    callback err, report?[0]?.properties?.cidr

scan = (cidr, callback) ->
  nmap.nmap 'scan', range: [cidr], callback


module.exports = {cidr, scan}
