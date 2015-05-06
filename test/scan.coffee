{cidr, scan} = require '../src/ip/scan'
nmap = require 'node-libnmap'
describe 'scan', ->
  it 'should perform', (done) ->
    cidr (err, ci) ->
      scan ci, (err, report) ->
        console.log r for r in report
        done(s)
