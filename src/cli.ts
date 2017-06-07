import program = require("commander")
import similar = require("./similar")
import fs_collector = require("./cli/file_collector")

const pkg = require("./../package.json")

const compare = (
  targets : string[],
  opts : synt.CLIOptions
) => {
  const files = fs_collector.files(targets)
  const nocolors : boolean = !!opts.disablecolors

  fs_collector.print(files, nocolors)

  const { js, ts } = similar.compare(files, opts)

  similar.print(js, nocolors)
  similar.print(ts, nocolors)
}

const configure = () => {
  program
    .version(pkg.version)
    .command("analyze [paths...]")
    .alias("a")
    .option(
      "-s, --similarity [number]",
      `Lowest % similarity to look for ` +
      `[default=${ similar.DEFAULT_THRESHOLD }].`)
    .option(
      "-m, --minlength [number]",
      `Default token length a function needs to be to compare it ` +
      `[default=${ similar.DEFAULT_TOKEN_LENGTH }].`)
    .option(
      "-n, --ngram [number]",
      `Specify ngram length for comparing token sequences. ` +
      `[default=${ similar.DEFAULT_NGRAM_LENGTH },2,3...]`)
    .option("-d, --disablecolors", "Disable color output")
    .option(
      "--estype [value]",
      "Set the JavaScript parser source type [default=module,script]")
    .action(compare)

  program.on("--help", () => {
    console.log("  Command specific help:")
    console.log("")
    console.log("    {cmd} -h, --help")
    console.log("")
    console.log("  Examples:")
    console.log("")
    console.log("    $ synt analyze lib")
    console.log("    $ synt analyze -s 90 foo.js bar.js baz.js")
    console.log("")
  })
}

const interpret = (argv : string[]) => {
  configure()
  program.parse(argv)
}

export = { interpret } as synt.Module.CLI
