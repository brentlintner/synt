"use strict";
var fs = require("fs");
var path = require("path");
var _ = require("lodash");
var walk_sync = require("walk-sync");
var chalk = require("chalk");
var all_files = function (target) {
    if (fs.statSync(target).isDirectory()) {
        var dirs = walk_sync(target, { directories: false });
        return _.map(dirs, function (dir) { return path.join(target, dir); });
    }
    else {
        return [target];
    }
};
var normalize_cli_targets = function (targets) {
    targets = _.concat([], targets);
    var files = _.uniq(_.reduce(targets, function (paths, target) {
        return _.concat(paths, all_files(target));
    }, []));
    files = _.map(files, function (file) {
        return path.relative(process.cwd(), file);
    });
    return _.filter(files, function (file) {
        return /\.(js|ts)$/.test(file);
    });
};
var print_found = function (files, nocolors) {
    return _.each(files, function (file) {
        if (nocolors) {
            console.log("found:", file);
        }
        else {
            console.log(chalk.gray("found:"), chalk.green(file));
        }
    });
};
module.exports = {
    files: normalize_cli_targets,
    print: print_found
};
