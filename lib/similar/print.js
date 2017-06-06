"use strict";
var _ = require("lodash");
var chalk = require("chalk");
var cardinal = require("cardinal");
var print = function (group, nocolors) {
    _.each(group, function (results, sim) {
        _.each(results, function (result) {
            var src = result[0], cmp = result[1];
            console.log("");
            var match_sim = sim + "% match";
            if (nocolors) {
                console.log(match_sim);
            }
            else {
                console.log(chalk.white.bgRed.bold(match_sim));
            }
            console.log("");
            if (nocolors) {
                console.log("in: " + src.path);
            }
            else {
                console.log(chalk.gray("in: ") + chalk.green(src.path));
            }
            console.log("");
            if (nocolors) {
                console.log(src.code);
            }
            else {
                console.log(cardinal.highlight(src.code, {
                    firstline: src.pos.start.line,
                    linenos: true
                }));
            }
            console.log("");
            if (src.path !== cmp.path) {
                if (nocolors) {
                    console.log("in: " + cmp.path);
                }
                else {
                    console.log(chalk.gray("in: ") + chalk.green(cmp.path));
                }
                console.log("");
            }
            if (nocolors) {
                console.log(cmp.code);
            }
            else {
                console.log(cardinal.highlight(cmp.code, {
                    firstline: cmp.pos.start.line,
                    linenos: true
                }));
            }
        });
    });
};
module.exports = { print: print };
