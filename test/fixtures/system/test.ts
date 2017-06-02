const foo = (a : string, b : number) : number => {
  console.log(b)

  if (!a && !b) {
    console.log(a)
  } else {
    return 1
  }
}

var f = function () {
}

function some_method = (x) => (a) => console.log("DS")

module haha {
  function Huz () {}
}

class Greeter {
  greeting: string;
  constructor(message: string) {
    this.greeting = message;
  }
  static greet(a, y, x) {
    let b = y + x
    return a + "Hello, " + this.greeting;
  }
}

class FooGreeter {
  constructor(message: string) {
    this.greeting = message;
  }
  static greet(a, y, x) {
    let b = x + y
    return a + "Hello, " + this.greeting;
  }
}

let greeter = new Greeter("world");
let foobar = function (x : number, s : any) : number[] {
  let a = [1, 2]
  let s = new Huz(function (t, r) {});
  a.forEach((i) => {
    console.log(i)
  })
  return a
}
