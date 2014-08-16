cli = require "commander"
fs = require "fs"
similar = require "./similar"
logger = require "./logger"
pkg = require "./../package"
log = logger.create "cli"

determine = (file_or_string) ->
  if fs.existsSync file_or_string
  then fs.readFileSync file_or_string, "utf-8"
  else file_or_string

run = (cli) ->
  diff = similar.compare
    compare: determine cli.compare
    to: determine cli.to
    algorithm: cli.algorithm
    language: cli.language
    ngram: cli.ngram

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
    console.log "    $ synt -c \"function(){}\"
                                -t \"function(){console.log(1)}\""
    console.log ""

  cli.parse process.argv

  run cli

module.exports =
  interpret: interpret
