express = require 'express'
express_lane = require 'express-lane'

routes = require './routes'

app = express()
router = express_lane app

app.use router.middleware()
routes.apply(router)

unless module.parent?
  port = process.env.PORT or 3000
  console.log "starting the app on port %d", port
  app.listen port

module.exports = app
