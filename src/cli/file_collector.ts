import fs = require("fs")
import path = require("path")
import _ = require("lodash")
import walk_sync = require("walk-sync")

// HACK: chalk types don't support import?
const chalk = require("chalk")

const all_files = (target : string) : string[] => {
  if (fs.statSync(target).isDirectory()) {
    const dirs = walk_sync(target, { directories: false })
    return _.map(dirs, (dir : string) => path.join(target, dir))
  } else {
    return [ target ]
  }
}

const normalize_cli_targets = (
  targets : string | string[]
) : string[] => {
  targets = _.concat([], targets)

  let files = _.uniq(_.reduce(targets, (paths, target) =>
      _.concat(paths, all_files(target)), []))

  files = _.map(files, (file : string) =>
    path.relative(process.cwd(), file))

  return _.filter(files, (file : string) =>
    /\.(js|ts)$/.test(file))
}

const print_found = (
  files : string[],
  nocolors : boolean
) =>
  _.each(files, (file) => {
    if (nocolors) {
      console.log("found:", file)
    } else {
      console.log(chalk.gray("found:"), chalk.green(file))
    }
  })

export = {
  files: normalize_cli_targets,
  print: print_found
}
