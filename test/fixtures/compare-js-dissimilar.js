function a(x) {
  // some comment yo
  console.log('aa');
  console.log('cc');
  console.log('a');
  console.log('ll');
}

function b(c, d, e, f) {
  if (c && d && e) {
    return 'hello'
  } else {
    c = 2;
    d = 7;
    e = 9;
  }

  switch (true) {
    case false:
      break;
    default:
      break;
  }
}

module.exports = {
  a: a,
  b: b
}
