"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.interpret = void 0;
const commander_1 = require("commander");
const espree = require("espree");
const similar = require("./similar");
const fs_collector = require("./cli/file_collector");
const pkg = require("./../package.json");
const compare = (targets, opts) => {
    const files = fs_collector.files(targets);
    const ecmaVersion = opts.ecmaVersion && opts.ecmaVersion != "latest" ?
        parseInt(opts.ecmaVersion) : opts.ecmaVersion;
    const { js, ts } = similar.compare(files, Object.assign(Object.assign({}, opts), { ecmaVersion }));
    similar.print(js, opts.color);
    similar.print(ts, opts.color);
    if (opts.exitCode && (Object.keys(js).length > 0 || Object.keys(ts).length > 0)) {
        process.exit(1);
    }
};
const configure = () => {
    commander_1.program
        .version(pkg.version)
        .command("analyze [paths...]")
        .alias("a")
        .option("-s, --similarity [number]", `Lowest % similarity to look for ` +
        `[default=${similar.DEFAULT_THRESHOLD}].`)
        .option("-m, --min-length [number]", `Default token length a function needs to be to compare it ` +
        `[default=${similar.DEFAULT_TOKEN_LENGTH}].`)
        .option("-g, --ngram [number]", `Specify ngram length for comparing token sequences. ` +
        `[default=${similar.DEFAULT_NGRAM_LENGTH},2,3...]`)
        .option("-n, --no-color", "Disable color output")
        .option("-e, --exit-code", "Exit with a nonzero code when issues found")
        .option("-t, --source-type [value]", "Set JS source type [default=module,script,commonjs]")
        .option("-a, --ecma-version [value]", `Set JS version [default=latest,${espree.supportedEcmaVersions.join(",")}]`)
        .action(compare);
    commander_1.program.on("--help", () => {
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
const interpret = (argv) => {
    configure();
    commander_1.program.parse(argv);
};
exports.interpret = interpret;
