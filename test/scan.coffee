{parse, scan} = require '../src/ip/scan'

nmap = """Starting Nmap 6.47 ( http://nmap.org ) at 2015-05-08 22:55 PDT
Nmap scan report for router.asus.com (192.168.1.1)
Host is up (0.0015s latency).
MAC Address: D8:50:E6:43:3D:B4 (Asustek Computer)
Nmap scan report for 192.168.1.52
Host is up (0.010s latency).
MAC Address: 00:0E:58:CE:39:FC (Sonos)
Nmap scan report for android-8ef8527b7fcc4659 (192.168.1.88)
Host is up (0.30s latency).
MAC Address: 10:68:3F:49:D2:8E (LG Electronics)
Nmap scan report for 192.168.1.153
Host is up (0.013s latency).
MAC Address: 00:0E:58:CE:3A:1C (Sonos)
Nmap scan report for 192.168.1.161
Host is up (0.16s latency).
MAC Address: 18:0C:AC:14:88:EE (Canon)
Nmap scan report for 192.168.1.166
Host is up (0.16s latency).
MAC Address: F0:4F:7C:3D:69:1E (Private)
Nmap scan report for SonosZP (192.168.1.199)
Host is up (0.014s latency).
MAC Address: 00:0E:58:50:89:20 (Sonos)
Nmap scan report for raspberrypi (192.168.1.202)
Host is up (0.0038s latency).
MAC Address: B8:27:EB:E3:F3:AE (Raspberry Pi Foundation)
Nmap scan report for SonosZB (192.168.1.224)
Host is up (0.012s latency).
MAC Address: 00:0E:58:41:9F:06 (Sonos)
Nmap scan report for Jeans-MBP (192.168.1.174)
Host is up.
Nmap done: 256 IP addresses (10 hosts up) scanned in 16.30 seconds
"""

describe 'scan', ->
  it 'should parse', ->
    console.log parse nmap
