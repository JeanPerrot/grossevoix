process.env.NODE_ENV = process.env.NODE_ENV || 'test'
console.log "using env #{process.env.NODE_ENV}"
chai = require 'chai'
global.fail = chai.assert.fail
global.expect = chai.expect
global.should = chai.should()
