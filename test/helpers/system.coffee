os = require "os"
path = require "path"
child_process = require "child_process"
chai = require "chai"
on_win = os.platform() == "win32"
expect = chai.expect

SYNT_BIN = path.join(__dirname, "..", "..", "bin", "synt")

exec = (args, cb, stdio) ->
  cmd = undefined

  cmd = "#{SYNT_BIN} #{args}"

  cli_args = cmd.split(" ")
  proc = child_process.spawn(
    "node",
    cli_args,
    stdio: stdio,
    env: process.env)

  out = ""
  err = ""
  error = undefined
  cb_called = undefined

  proc.stdout.on "data", (d) -> out += d
  proc.stderr.on "data", (d) -> err += d

  proc.on "error", (e) ->
    unless cb_called
      cb_called = true
      if on_win
        out = new Buffer(out).toString("utf-8").replace(/\r\n/g, "\n")
      else
        out = new Buffer(out).toString("utf-8")
      cb(
        e,
        out,
        new Buffer(err).toString("utf-8"))

  proc.on "close", (code) ->
    unless cb_called
      cb_called = true
      if on_win
        out = new Buffer(out).toString("utf-8").replace(/\r\n/g, "\n")
      else
        out = new Buffer(out).toString("utf-8")
      cb(
        { code: code },
        out,
        new Buffer(err).toString("utf-8"))

  proc

module.exports = exec: exec
