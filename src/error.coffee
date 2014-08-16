logger = require './logger'
log = logger.create 'error'

exit = (err) ->
  log.error err
  process.exit 1

module.exports = exit
