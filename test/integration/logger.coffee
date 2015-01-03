logger = require "./../../lib/logger"
log = logger.create "testing"

describe "integration :: logger", ->
  it 'can toggle verbose', ->
    logger.verbose true
    logger.verbose false
