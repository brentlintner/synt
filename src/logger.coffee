minilog = require 'minilog'
fs = require 'fs'
filter = new minilog.Filter()

default_filter = ->
  filter.allow /.*/, 'info'
  filter.allow /.*/, 'warn'
  filter.defaultResult = false

quiet = -> filter.clear()

verbose = (is_verbose) ->
  if is_verbose
    filter.clear()
    filter.allow /.*/, 'debug'
  else
    default_filter()

init = () ->
  minilog
    .pipe filter
    .pipe minilog.backends.nodeConsole.formatNpm
    .pipe minilog.backends.nodeConsole

  default_filter()

module.exports =
  create: minilog,
  verbose: verbose,
  quiet: quiet

init()
