"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.print = exports.compare = exports.DEFAULT_TOKEN_LENGTH = exports.DEFAULT_THRESHOLD = exports.DEFAULT_NGRAM_LENGTH = void 0;
const _ = require("lodash");
const ngram = require("./similar/ngram");
const parse_js = require("./similar/javascript");
const parse_ts = require("./similar/typescript");
const print_1 = require("./similar/print");
Object.defineProperty(exports, "print", { enumerable: true, get: function () { return print_1.print; } });
const DEFAULT_NGRAM_LENGTH = 1;
exports.DEFAULT_NGRAM_LENGTH = DEFAULT_NGRAM_LENGTH;
const DEFAULT_THRESHOLD = 70;
exports.DEFAULT_THRESHOLD = DEFAULT_THRESHOLD;
const DEFAULT_TOKEN_LENGTH = 10;
exports.DEFAULT_TOKEN_LENGTH = DEFAULT_TOKEN_LENGTH;
const similarity = (src, cmp) => {
    const a = _.uniq(src);
    const b = _.uniq(cmp);
    const i = _.intersection(a, b);
    const u = _.union(a, b);
    return _.toNumber(_.toNumber((i.length / u.length) * 100)
        .toFixed(0));
};
const parse_token_length = (str) => _.isEmpty(str) ?
    DEFAULT_TOKEN_LENGTH :
    _.toNumber(str);
const parse_ngram_length = (str) => _.isEmpty(str) ?
    DEFAULT_NGRAM_LENGTH :
    _.toNumber(str);
const parse_threshold = (str) => {
    const threshold = _.toNumber(str);
    return threshold || DEFAULT_THRESHOLD;
};
const is_ts_ancestor = (src, cmp) => {
    let match = false;
    let last = src.ast;
    while (true) {
        const { parent } = last;
        if (parent === cmp.ast)
            match = true;
        if (!parent || last === parent || match)
            break;
        last = parent;
    }
    return match;
};
const false_positive = (src, cmp, t_len) => {
    const same_node = () => cmp.ast === src.ast;
    const size_is_too_different = () => {
        const l1 = src.tokens.length;
        const l2 = cmp.tokens.length;
        return l1 * 2 < l2 || l2 * 2 < l1;
    };
    const one_is_too_short = () => src.tokens.length < t_len ||
        cmp.tokens.length < t_len;
    const subset_of_other = () => {
        const is_eithers_ancestor = () => is_ts_ancestor(src, cmp) ||
            is_ts_ancestor(cmp, src);
        const is_eithers_middle = () => {
            const src_j = src.tokens.join("");
            const cmp_j = cmp.tokens.join("");
            return src_j !== cmp_j &&
                (_.includes(src_j, cmp_j) ||
                    _.includes(cmp_j, src_j));
        };
        return is_eithers_ancestor() || is_eithers_middle();
    };
    const both_are_not_classes = () => (src.is_class && !cmp.is_class) ||
        (!src.is_class && cmp.is_class);
    return same_node() ||
        both_are_not_classes() ||
        subset_of_other() ||
        one_is_too_short() ||
        size_is_too_different();
};
const each_pair = (items, callback) => {
    _.each(items, (src) => {
        _.each(items, (cmp) => {
            callback(src, cmp);
        });
    });
};
const filter_redundencies = (group) => {
    _.each(group, (results, sim) => {
        group[sim] = _.reduce(results, (new_arr, result) => {
            const already_added = _.some(new_arr, (result_two) => _.xor(result, result_two).length === 0);
            if (!already_added) {
                new_arr.push(result);
            }
            return new_arr;
        }, []);
    });
    return group;
};
const _compare = (files, ftype, opts) => {
    const is_ts = ftype === "ts";
    const is_file = is_ts ? /\.ts$/ : /\.js$/;
    files = _.filter(files, (file) => is_file.test(file));
    const parse = is_ts ? parse_ts : parse_js;
    const items = parse.find(files, opts);
    const group = {};
    const t_len = parse_token_length(_.toString(opts.minLength));
    const n_len = parse_ngram_length(_.toString(opts.ngram));
    const sim_min = parse_threshold(_.toString(opts.similarity));
    each_pair(items, (src, cmp) => {
        if (false_positive(src, cmp, t_len))
            return;
        const src_grams = ngram.generate(src.tokens, n_len);
        const cmp_grams = ngram.generate(cmp.tokens, n_len);
        const val = similarity(src_grams, cmp_grams);
        if (val < sim_min)
            return;
        if (_.isEmpty(group[val]))
            group[val] = [];
        group[val].push([src, cmp]);
    });
    return filter_redundencies(group);
};
const compare = (files, opts = {}) => {
    files = _.concat([], files);
    const js_group = _compare(files, "js", opts);
    const ts_group = _compare(files, "ts", opts);
    return { js: js_group, ts: ts_group };
};
exports.compare = compare;
