path = require "path"
child_process = require "child_process"
project_root = path.resolve(path.join __dirname, "..", "..")
logger = require "./../logger"
log = logger.create "exec"

exec = (cmd, cb) ->
  child_process.exec cmd,
    cwd: project_root
    env: process.env
  , (err, stdout, stderr) ->
    process.stdout.write stderr if stderr
    process.stdout.write stdout

    if err
      log.error "subscript failed!"
      log.error err

    if cb then cb err, stdout, stderr

module.exports = exec
