"use strict";
var program = require("commander");
var similar = require("./similar");
var fs_collector = require("./cli/file_collector");
var pkg = require("./../package.json");
var compare = function (targets, opts) {
    var files = fs_collector.files(targets);
    var nocolors = !!opts.disablecolors;
    fs_collector.print(files, nocolors);
    var _a = similar.compare(files, opts), js = _a.js, ts = _a.ts;
    similar.print(js, nocolors);
    similar.print(ts, nocolors);
};
var configure = function () {
    program
        .version(pkg.version)
        .command("analyze [paths...]")
        .alias("a")
        .option("-s, --similarity [number]", "Lowest % similarity to look for " +
        ("[default=" + similar.DEFAULT_THRESHOLD + "]."))
        .option("-m, --minlength [number]", "Default token length a function needs to be to compare it " +
        ("[default=" + similar.DEFAULT_TOKEN_LENGTH + "]."))
        .option("-n, --ngram [number]", "Specify ngram length for comparing token sequences. " +
        ("[default=" + similar.DEFAULT_NGRAM_LENGTH + ",2,3...]"))
        .option("-d, --disablecolors", "Disable color output")
        .action(compare);
    program.on("--help", function () {
        console.log("  Command specific help:");
        console.log("");
        console.log("    {cmd} -h, --help");
        console.log("");
        console.log("  Examples:");
        console.log("");
        console.log("    $ synt analyze lib");
        console.log("    $ synt analyze -s 90 foo.js bar.js baz.js");
        console.log("");
    });
};
var interpret = function (argv) {
    configure();
    program.parse(argv);
};
module.exports = { interpret: interpret };
