import * as fs from "fs"
import * as path from "path"
import * as _ from "lodash"
import walk_sync = require("walk-sync")

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

  let files : string[] = _.uniq(_.reduce(targets,
    (paths : string[], target : string) =>
      _.concat(paths, all_files(target)), []))

  files = _.map(files, (file : string) =>
    path.relative(process.cwd(), file))

  return _.filter(files, (file : string) =>
    /\.(js|ts)$/.test(file))
}

export {
  normalize_cli_targets as files
}
