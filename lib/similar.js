"use strict";
var _ = require("lodash");
var ngram = require("./similar/ngram");
var parse_js = require("./similar/javascript");
var parse_ts = require("./similar/typescript");
var print = require("./similar/print");
var DEFAULT_NGRAM_LENGTH = 1;
var DEFAULT_THRESHOLD = 70;
var DEFAULT_TOKEN_LENGTH = 10;
var similarity = function (src, cmp) {
    var a = _.uniq(src);
    var b = _.uniq(cmp);
    var i = _.intersection(a, b);
    var u = _.union(a, b);
    return _.toNumber(_.toNumber((i.length / u.length) * 100)
        .toFixed(0));
};
var parse_token_length = function (str) {
    return _.isEmpty(str) ?
        DEFAULT_TOKEN_LENGTH :
        _.toNumber(str);
};
var parse_ngram_length = function (str) {
    return _.isEmpty(str) ?
        DEFAULT_NGRAM_LENGTH :
        _.toNumber(str);
};
var parse_threshold = function (str) {
    var threshold = _.toNumber(str);
    return threshold || DEFAULT_THRESHOLD;
};
var is_ts_ancestor = function (src, cmp) {
    var match = false;
    var last = src.ast;
    while (true) {
        var parent_1 = last.parent;
        if (parent_1 === cmp.ast)
            match = true;
        if (!parent_1 || last === parent_1 || match)
            break;
        last = parent_1;
    }
    return match;
};
var false_positive = function (src, cmp, t_len) {
    var same_node = function () { return cmp.ast === src.ast; };
    var size_is_too_different = function () {
        var l1 = src.tokens.length;
        var l2 = cmp.tokens.length;
        return l1 * 2 < l2 || l2 * 2 < l1;
    };
    var one_is_too_short = function () {
        return src.tokens.length < t_len ||
            cmp.tokens.length < t_len;
    };
    var subset_of_other = function () {
        var is_eithers_ancestor = function () {
            return is_ts_ancestor(src, cmp) ||
                is_ts_ancestor(cmp, src);
        };
        var is_eithers_middle = function () {
            var src_j = src.tokens.join("");
            var cmp_j = cmp.tokens.join("");
            return src_j !== cmp_j &&
                (_.includes(src_j, cmp_j) ||
                    _.includes(cmp_j, src_j));
        };
        return is_eithers_ancestor() || is_eithers_middle();
    };
    var both_are_not_classes = function () {
        return (src.is_class && !cmp.is_class) ||
            (!src.is_class && cmp.is_class);
    };
    return same_node() ||
        both_are_not_classes() ||
        subset_of_other() ||
        one_is_too_short() ||
        size_is_too_different();
};
var each_pair = function (items, callback) {
    _.each(items, function (src) {
        _.each(items, function (cmp) {
            callback(src, cmp);
        });
    });
};
var filter_redundencies = function (group) {
    _.each(group, function (results, sim) {
        group[sim] = _.reduce(results, function (new_arr, result) {
            var already_added = _.some(new_arr, function (result_two) {
                return _.xor(result, result_two).length === 0;
            });
            if (!already_added) {
                new_arr.push(result);
            }
            return new_arr;
        }, []);
    });
    return group;
};
var _compare = function (files, ftype, n_len, t_len, sim_min) {
    var is_ts = ftype === "ts";
    var is_file = is_ts ? /\.ts$/ : /\.js$/;
    files = _.filter(files, function (file) { return is_file.test(file); });
    var parse = is_ts ? parse_ts : parse_js;
    var items = parse.find(files);
    var group = {};
    each_pair(items, function (src, cmp) {
        if (false_positive(src, cmp, t_len))
            return;
        var src_grams = ngram.generate(src.tokens, n_len);
        var cmp_grams = ngram.generate(cmp.tokens, n_len);
        var val = similarity(src_grams, cmp_grams);
        if (val < sim_min)
            return;
        if (_.isEmpty(group[val]))
            group[val] = [];
        group[val].push([src, cmp]);
    });
    return filter_redundencies(group);
};
var compare = function (files, opts) {
    if (opts === void 0) { opts = {}; }
    files = _.concat([], files);
    var t_len = parse_token_length(_.toString(opts.minlength));
    var n_len = parse_ngram_length(_.toString(opts.ngram));
    var threshold = parse_threshold(_.toString(opts.similarity));
    var js_group = _compare(files, "js", n_len, t_len, threshold);
    var ts_group = _compare(files, "ts", n_len, t_len, threshold);
    return { js: js_group, ts: ts_group };
};
module.exports = {
    DEFAULT_NGRAM_LENGTH: DEFAULT_NGRAM_LENGTH,
    DEFAULT_THRESHOLD: DEFAULT_THRESHOLD,
    DEFAULT_TOKEN_LENGTH: DEFAULT_TOKEN_LENGTH,
    compare: compare,
    print: print.print
};
