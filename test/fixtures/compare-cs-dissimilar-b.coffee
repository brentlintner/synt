b = (c, d, e, f) ->
  if c && d && e
    "hello"
  else
    c = 2
    d = 7
    e = 9

  switch c
    when "foo" then d
    else e
