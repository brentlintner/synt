var a = function (d, e) {
  var msg = 'hello';
  console.log(msg)

  if (d) return e;
}

var b = function (d, e) {
  var msg = 'world'
  console.log(msg)

  if (d) {
    return e;
  }
}

module.exports = {
  a: a,
  b: b
}
