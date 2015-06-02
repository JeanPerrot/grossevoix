express = require 'express'
express_lane = require 'express-lane'
events = require './net/events'
pins = require './gpio/events'
synch = require './gpio/synch'
require './welcome/home'
routes = require './routes'

app = express()
router = express_lane app

app.use router.middleware()
routes.apply(router)

unless module.parent?
  events.start()
  pins.start()
  synch()
  port = process.env.PORT or 49160
  console.log "starting the app on port %d", port
  app.listen port

module.exports = app
