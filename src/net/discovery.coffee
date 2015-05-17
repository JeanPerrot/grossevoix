'use strict'
os = require 'os'

module.exports = () ->
  ifaces = os.networkInterfaces()
  ret = {}
  for ifname in Object.keys(ifaces)
    alias = 0
    for iface in ifaces[ifname]
      if ('IPv4' != iface.family || iface.internal != false)
        #  skip over internal (i.e. 127.0.0.1) and non-ipv4 addresses
        continue
      if alias >= 1
        # this single interface has multiple ipv4 addresses
        # console.log(ifname + ':' + alias, iface.address);
        ret[ifname] = iface.address
      else
        ret[ifname] = iface.address
        # this interface has only one ipv4 adress
        console.log(ifname, iface.address);
  ret
