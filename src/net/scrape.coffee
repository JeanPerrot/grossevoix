# scrape the router client data
request = require 'superagent'
{parseString} = require 'xml2js'

raw_lease = (callback) ->
  request.get('http://192.168.1.1/getdhcpLeaseInfo.asp')
    .auth('admin', 'Nefertiti')
    .end (err, res) ->
      callback err, res?.text

# [ 'value=XYZ' ] -> 'XYZ'
coerce = ([val,...]) ->
  return null if val is 'None'
  return val.substring 6

coerceObj = ({mac, hostname}) ->
  mac: coerce mac
  hostname: coerce hostname

lease = (callback) ->
  raw_lease (err, xml) ->
    parseString xml, (err, res)->
      clients = res?.dhcplease?.client or []
      callback err, (coerceObj client for client in clients)

raw_clients = (callback) ->
  request.get('http://192.168.1.1/update_clients.asp')
    .auth('admin', 'Nefertiti')
    .end (err, res) ->
      callback err, res?.text

parse_client = (str) ->
  regexp = /<6>([^>]*)>([^>]*)>([^>]*)>/
  [_, name, ip, mac] = regexp.exec str
  {name, ip, mac}

clients = (callback) ->
  raw_clients (err, res) ->
    return callback err if err?
    arr = eval(res).split ','
    callback null, (parse_client client for client in arr)

module.exports = {lease, clients}
