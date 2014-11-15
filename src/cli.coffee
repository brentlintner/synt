path = require "path"
child_process = require "child_process"
shell = require "shelljs"
app = require "commander"
ruby = require "./cli/ruby"
similar = require "./similar"
error = require "./error"
logger = require "./logger"
pkg = require "./../package"
log = logger.create "cli"
synt_rb = path.join __dirname, "../bin/cli-rb"
synt_hs = path.join __dirname, "../bin/cli-hs"
project_root = path.join __dirname, ".."

abs_path = (p) -> path.join process.cwd(), p

exec = (cmd) ->
  res = child_process.exec cmd, {
    cwd: project_root
    env: process.env
  }, (error, stdout, stderr) ->
    process.stdout.write stderr if stderr
    process.stdout.write stdout

    if error
      log.error "subscript failed!"
      log.error error
      process.exit 1

similar_hs = (o) ->
  if not shell.which "cabal"
    error "Can not cabal in PATH- Haskell support will not work."

  cmd = synt_hs
  cmd += " -s " if o.stringCompare
  cmd += " -c \"#{abs_path o.compare}\"" if o.compare
  cmd += " -t \"#{abs_path o.to}\"" if o.to
  cmd += " -m " + o.threshold if o.threshold
  cmd += " -n " + o.ngram if o.ngram
  cmd += " -a " + o.algorithm if o.algorithm

  exec cmd

similar_rb = (o) ->
  if not shell.which "bundle"
    error "Can not find a bundle in PATH- Ruby support will not work."

  cmd = synt_rb
  cmd += " -c \"#{o.compare}\"" if o.compare
  cmd += " -t \"#{o.to}\"" if o.to
  cmd += " -d " + o.threshold if o.threshold
  cmd += " -n " + o.ngram if o.ngram
  cmd += " -a " + o.algorithm if o.algorithm

  exec cmd

run = (cli) ->
  if cli.language == "rb"
    similar_rb cli
  else if cli.language == "hs"
    similar_hs cli
  else
    diff = similar.compare cli

    console.log "Inputs are %#{Math.floor diff} similar."

    if diff < cli.threshold
      log.error "Similarity threshold of #{cli.threshold} hit."
      process.exit 1

print = (diff) ->
  console.log "Inputs are %#{Math.floor diff} similar."

check_threshold = (diff, threshold=0) ->
  if diff < threshold
    log.error "Similarity threshold of #{app.threshold} hit."
    process.exit 1

compare = (app) ->
  switch app.language
    when "rb" then ruby.compare app
    when "coffee" then similar.compare app
    else similar.compare app

run = (app) ->
  if app.language == "rb"
    ruby.compare app
  else
    diff = compare app
    check_threshold diff, app.threshold
    print diff

interpret = ->
  app
    .version pkg.version
    .usage "[options]"
    .option "-c, --compare [thing]", "File or String to compare to something."
    .option "-t, --to [thing]", "File or String to compare against."
    .option "-s, --string-compare", "Treat -c and -t as string,
                                    instead of file paths."
    .option "-l, --language [type]", "Type of language that is being compared
                                      [default=js,coffee,rb,generic]."
    .option "-a, --algorithm [type]",
            "Similarity algorithm [default=jaccard,tanimoto,experimental]."
    .option "-n, --ngram [value]",
            "Specify what ngrams are generated and used for
             comparing token sequences. [default=1,2,4..5,10,...,all]"
    .option "-d, --threshold [value].",
            "Similarity threshold and exit with error."

  app.on "--help", ->
    console.log "  Examples:"
    console.log ""
    console.log "    $ synt --compare foo.js --to bar.js"
    console.log "    $ synt -s -c \"function(){}\"
                               -t \"function(){console.log(1)}\""
    console.log ""

  app.parse process.argv

  run app

module.exports =
  interpret: interpret
