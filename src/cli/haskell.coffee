path = require "path"
shell = require "shelljs"
exec = require "./exec"
error = require "./../error"
logger = require "./../logger"
log = logger.create "haskell"
synt_hs = path.resolve(path.join __dirname, "..", "..", "bin", "cli-hs")

abs_path = (p) -> path.join process.cwd(), p

compare_haskell = (app) ->
  if not shell.which "cabal"
    return error "Can not find cabal in PATH- Haskell support will not work."

  cmd = synt_hs
  cmd += " -s " if app.stringCompare

  # TODO: should port just handle this?
  if !app.stringCompare
    cmd += " -c \"#{abs_path app.compare}\" " if app.compare
    cmd += " -t \"#{abs_path app.to}\" " if app.to
  else
    cmd += " -c \"#{app.compare}\" " if app.compare
    cmd += " -t \"#{app.to}\" " if app.to

  cmd += " -m #{app["min-threshold"]} " if app["min-threshold"]
  cmd += " -n #{app.ngram} " if app.ngram
  cmd += " -a #{app.algorithm} " if app.algorithm

  exec cmd

module.exports = compare: compare_haskell
