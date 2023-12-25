import * as _ from "lodash"
import * as ngram from "./similar/ngram"
import * as parse_js from "./similar/javascript"
import * as parse_ts from "./similar/typescript"
import { print } from "./similar/print"

const DEFAULT_NGRAM_LENGTH = 1
const DEFAULT_THRESHOLD    = 70
const DEFAULT_TOKEN_LENGTH = 10

// http://en.wikipedia.org/wiki/Jaccard_index
const similarity = (
  src : synt.TokenList,
  cmp : synt.TokenList
) : number => {
  const a = _.uniq(src)
  const b = _.uniq(cmp)
  const i = _.intersection(a, b)
  const u = _.union(a, b)

  return _.toNumber(
      _.toNumber((i.length / u.length) * 100)
        .toFixed(0))
}

const parse_token_length = (str : string) : number =>
  _.isEmpty(str) ?
    DEFAULT_TOKEN_LENGTH :
    _.toNumber(str)

const parse_ngram_length = (str : string) : number =>
  _.isEmpty(str) ?
    DEFAULT_NGRAM_LENGTH :
    _.toNumber(str)

const parse_threshold = (str : string) : number => {
  const threshold = _.toNumber(str)
  return threshold || DEFAULT_THRESHOLD
}

const is_ts_ancestor = (
  src : synt.TSParseResult,
  cmp : synt.TSParseResult
) : boolean => {
  let match = false

  let last = src.ast

  while (true) {
    const { parent } = last
    if (parent === cmp.ast) match = true
    if (!parent || last === parent || match) break
    last = parent
  }

  return match
}

const false_positive = (
  src : synt.ParseResult,
  cmp : synt.ParseResult,
  t_len : number
) => {
  const same_node = () => cmp.ast === src.ast

  const size_is_too_different = () => {
    const l1 = src.tokens.length
    const l2 = cmp.tokens.length
    return l1 * 2 < l2 || l2 * 2 < l1
  }

  const one_is_too_short = () =>
    src.tokens.length < t_len ||
      cmp.tokens.length < t_len

  // HACK: TypeScript provides a parent chain
  //       Esprima does not (out of the box), so we
  //       also use hacky token string check to catch all
  const subset_of_other = () : boolean => {
    const is_eithers_ancestor = () : boolean =>
      is_ts_ancestor(
        (src as synt.TSParseResult),
        (cmp as synt.TSParseResult)) ||
      is_ts_ancestor(
        (cmp as synt.TSParseResult),
        (src as synt.TSParseResult))

    const is_eithers_middle = () : boolean => {
      const src_j = src.tokens.join("")
      const cmp_j = cmp.tokens.join("")
      return src_j !== cmp_j &&
        (_.includes(src_j, cmp_j) ||
          _.includes(cmp_j, src_j))
    }

    return is_eithers_ancestor() || is_eithers_middle()
  }

  const both_are_not_classes = () : boolean =>
    (src.is_class && !cmp.is_class) ||
      (!src.is_class && cmp.is_class)

  return same_node() ||
    both_are_not_classes() ||
      subset_of_other() ||
        one_is_too_short() ||
          size_is_too_different()
}

const each_pair = (
  items : synt.ParseResult[],
  callback : (
    src : synt.ParseResult,
    cmp : synt.ParseResult
  ) => void
) : void => {
  _.each(items, (src) => {
    _.each(items, (cmp) => {
      callback(src, cmp)
    })
  })
}

const filter_redundencies = (
  group : synt.ParseResultGroup
) : synt.ParseResultGroup => {
  _.each(group, (
    results : synt.ParseResultMatchList,
    sim : string
  ) => {
    group[sim] = _.reduce(
      results,
      (
        new_arr : synt.ParseResultMatchList,
        result : synt.ParseResult[]
      ) => {
        const already_added : boolean = _.some(
          new_arr, (result_two : synt.ParseResult[]) =>
            _.xor(result, result_two).length === 0)
        if (!already_added) { new_arr.push(result) }
        return new_arr
      },
      ([] as synt.ParseResultMatchList))
  })

  return group
}

const _compare = (
  files : string[],
  ftype : string,
  opts  : synt.CompareOptions
) : synt.ParseResultGroup => {
  const is_ts = ftype === "ts"
  const is_file = is_ts ? /\.ts$/ : /\.js$/
  files = _.filter(files, (file) => is_file.test(file))
  const parse = is_ts ? parse_ts : parse_js
  const items : synt.ParseResult[] = parse.find(files, opts)
  const group : synt.ParseResultGroup = {}
  const t_len = parse_token_length(_.toString(opts.minLength))
  const n_len = parse_ngram_length(_.toString(opts.ngram))
  const sim_min = parse_threshold(_.toString(opts.similarity))

  each_pair(items, (src : synt.ParseResult, cmp : synt.ParseResult) => {
    if (false_positive(src, cmp, t_len)) return
    const src_grams = ngram.generate(src.tokens, n_len)
    const cmp_grams = ngram.generate(cmp.tokens, n_len)
    const val = similarity(src_grams, cmp_grams)
    if (val < sim_min) return
    if (_.isEmpty(group[val])) group[val] = []
    group[val].push([src, cmp])
  })

  return filter_redundencies(group)
}

const compare = (
  files : string[],
  opts : synt.CompareOptions = {}
) : synt.ParseResultGroups => {
  files = _.concat([], files)
  const js_group = _compare(files, "js", opts)
  const ts_group = _compare(files, "ts", opts)
  return { js: js_group, ts: ts_group }
}

export {
  DEFAULT_NGRAM_LENGTH,
  DEFAULT_THRESHOLD,
  DEFAULT_TOKEN_LENGTH,
  compare,
  print
}
