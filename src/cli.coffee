app = require "commander"
ruby = require "./cli/ruby"
haskell = require "./cli/haskell"
similar = require "./similar"
error = require "./error"
logger = require "./logger"
pkg = require "./../package"
log = logger.create "cli"

print = (sim) ->
  log.info "Inputs are #{Math.floor sim}% similar."

check_threshold = (sim, threshold=0) ->
  if sim < threshold
    error "Similarity threshold of #{threshold}% hit."

compare = (app) ->
  switch app.language
    when "rb" then ruby.compare app
    when "hs" then haskell.compare app
    else
      similar.compare app, (err, sim) ->
        error err if err
        check_threshold sim, app.minThreshold
        print sim

configure = ->
  app
    .version pkg.version
    .usage "[options]"
    .option "-c, --compare [thing]", "File or String to compare to something."
    .option "-t, --to [thing]", "File or String to compare against."
    .option "-s, --string-compare", "Treat -c and -t as string,
                                    instead of file paths."
    .option "-l, --language [type]", "Type of language that is being compared
                                      [default=js,coffee,rb,latin]."
    .option "-a, --algorithm [type]",
            "Similarity algorithm [default=jaccard,tanimoto]."
    .option "-n, --ngram [value]",
            "Specify what ngrams are generated and used for
             comparing token sequences. [default=1,2,4..5,10,...,all]"
    .option "-m, --min-threshold [value].",
            "Similarity threshold and exit with error."

  app.on "--help", ->
    console.log "  Examples:"
    console.log ""
    console.log "    $ synt --compare foo.js --to bar.js"
    console.log "    $ synt -s -c \"function(){}\"
                               -t \"function(){console.log(1)}\""
    console.log ""

interpret = (argv) ->
  configure()
  app.parse argv
  compare app

module.exports =
  interpret: interpret
