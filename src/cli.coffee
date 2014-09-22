path = require "path"
cli = require "commander"
shell = require "shelljs"
similar = require "./similar"
error = require "./error"
logger = require "./logger"
pkg = require "./../package"
log = logger.create "cli"
synt_rb = path.join __dirname, "../bin/cli-rb"
synt_hs = path.join __dirname, "../bin/cli-hs"

abs_path = (p) -> path.join process.cwd(), p

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

  res = shell.exec cmd

  if res.code != 0
    log.error "synt-hs script failed!"
    process.exit res.code

similar_rb = (o) ->
  if not shell.which "bundle"
    error "Can not find a bundle in PATH- Ruby support will not work."

  cmd = synt_rb

  cmd += " -c \"#{o.compare}\"" if o.compare
  cmd += " -t \"#{o.to}\"" if o.to
  cmd += " -d " + o.threshold if o.threshold
  cmd += " -n " + o.ngram if o.ngram
  cmd += " -a " + o.algorithm if o.algorithm

  res = shell.exec cmd

  process.stdout.write res.output

  if res.code != 0
    log.error "synt-rb script failed!"
    process.exit res.code

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

interpret = ->
  cli
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

  cli.on "--help", ->
    console.log "  Examples:"
    console.log ""
    console.log "    $ synt --compare foo.js --to bar.js"
    console.log "    $ synt -s -c \"function(){}\"
                               -t \"function(){console.log(1)}\""
    console.log ""

  cli.parse process.argv

  run cli

module.exports =
  interpret: interpret
