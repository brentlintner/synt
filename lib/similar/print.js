"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.print = void 0;
const _ = require("lodash");
const cardinal = require("cardinal");
const chalk = require("chalk");
const print = (group, color) => {
    _.each(group, (results, sim) => {
        _.each(results, (result) => {
            const [src, cmp] = result;
            console.log("");
            const match_sim = sim + "% similar";
            if (color) {
                console.log(chalk.red.bold(match_sim));
            }
            else {
                console.log(match_sim);
            }
            console.log("");
            if (color) {
                console.log(chalk.gray("in: ") + chalk.green(src.path));
            }
            else {
                console.log(`in: ${src.path}`);
            }
            console.log("");
            if (color) {
                console.log(cardinal.highlight(src.code, {
                    firstline: src.pos.start.line,
                    linenos: true
                }));
            }
            else {
                console.log(src.code.split("\n").map((line, idx) => {
                    return `${src.pos.start.line + idx + 1}: ${line}`;
                }).join("\n"));
            }
            console.log("");
            if (src.path !== cmp.path) {
                if (color) {
                    console.log(chalk.gray("in: ") + chalk.green(cmp.path));
                }
                else {
                    console.log(`in: ${cmp.path}`);
                }
                console.log("");
            }
            if (color) {
                console.log(cardinal.highlight(cmp.code, {
                    firstline: cmp.pos.start.line,
                    linenos: true
                }));
            }
            else {
                console.log(cmp.code.split("\n").map((line, idx) => {
                    return `${cmp.pos.start.line + idx + 1}: ${line}`;
                }).join("\n"));
            }
        });
    });
};
exports.print = print;
