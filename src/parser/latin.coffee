ParseLatin = require "parse-latin"

tokenize_parse_latin = (string) ->
  latin = new ParseLatin()
  latin.tokenize string

normalize_parse_latin = (tokens) ->
  tokens.filter (token) ->
    token.type != "WhiteSpaceNode"
  .map (token) ->
    if token.children
      token.children.reduce (value, prop) ->
        value + prop.value
      , ""
    else
      token.value

module.exports =
  normalize: normalize_parse_latin
  tokenize: tokenize_parse_latin
