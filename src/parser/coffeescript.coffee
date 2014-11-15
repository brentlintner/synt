coffee = require "coffee-script"

normalize_coffee_tokens = (token_list) ->
  token_list
    .filter (t) -> t[0] != "TERMINATOR" &&
                   t[0] != "OUTDENT" &&
                   t[0] != "INDENT"
    .map (t) -> if /^[A-Z_]*$/.test t[0] then t[1] else t[0]

tokenize_coffeescript = coffee.tokens

module.exports =
  normalize: normalize_coffee_tokens
  tokenize: tokenize_coffeescript
