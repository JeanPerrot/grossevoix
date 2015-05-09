# sudo nmap -sP 192.168.1.0/24

require 'shelljs/global'

nmap = (callback) ->
  exec 'sudo nmap -sP 192.168.1.0/24', callback

parseclient = (report, mac, status) ->
  regex = /Nmap scan report for ((.*) \(((\d+[.]){3}\d+)\)|(\d+[.]){3}\d+)/
  [_, ip2, name, ip1, ...] = regex.exec report
  mac_regex = /MAC Address: (.*) \((.*)\)/
  if mac
    [_, mac, manufacturer,...] = mac_regex.exec mac
  {name, manufacturer, mac, ip: ip1 or ip2}

is_header = (line)->
  line is '' or (line.indexOf('Starting') is 0) or (line.indexOf('Strange error') is 0)

parse = (out) ->
  clients = []
  [lines..., footer] = out.match(/[^\r\n]+/g)
  while is_header lines[0]
    [header, lines...] = lines
  try
    while lines.length
      [report, status, mac, lines...] = lines
      clients.push parseclient report, mac, status
  catch error
    console.log error
  clients

scan = (callback) ->
  nmap (err, res) ->
    callback err, parse res

module.exports = {scan, parse}
