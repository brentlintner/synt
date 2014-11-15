esprima = require "esprima"

normalize_esprima_tokens = (token_list) ->
  token_list.map (t) -> t.value

tokenize_javascript = esprima.tokenize

module.exports =
  normalize: normalize_esprima_tokens
  tokenize: tokenize_javascript
