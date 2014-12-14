path = require "path"
shell = require "shelljs"
error = require "./../error"
logger = require "./../logger"
log = logger.create "ruby"
synt_rb = path.join __dirname, "..", "..", "ruby", "bin", "synt"

compare_ruby = (app) ->
  if not shell.which "bundle"
    error "Can not find a bundle in PATH- Ruby support will not work."

  cmd = synt_rb

  cmd += " -c \"#{app.compare}\"" if app.compare
  cmd += " -t \"#{app.to}\"" if app.to
  cmd += " -d " + app.threshold if app.threshold
  cmd += " -n " + app.ngram if app.ngram
  cmd += " -a " + app.algorithm if app.algorithm

  res = shell.exec cmd

  if res.code != 0
    log.error "script failed!"
    process.exit res.code

module.exports = compare: compare_ruby
