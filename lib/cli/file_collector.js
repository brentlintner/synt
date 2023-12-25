"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.files = void 0;
const fs = require("fs");
const path = require("path");
const _ = require("lodash");
const walk_sync = require("walk-sync");
const all_files = (target) => {
    if (fs.statSync(target).isDirectory()) {
        const dirs = walk_sync(target, { directories: false });
        return _.map(dirs, (dir) => path.join(target, dir));
    }
    else {
        return [target];
    }
};
const normalize_cli_targets = (targets) => {
    targets = _.concat([], targets);
    let files = _.uniq(_.reduce(targets, (paths, target) => _.concat(paths, all_files(target)), []));
    files = _.map(files, (file) => path.relative(process.cwd(), file));
    return _.filter(files, (file) => /\.(js|ts)$/.test(file));
};
exports.files = normalize_cli_targets;
