const foo = (a, b) => {
  console.log(b)

  if (a) {
    console.log(a)
  }
}

const foo_two = (a, b) => {
  console.log()

  if (!a) {
    console.log(a)
  }
}

const bar = () => true && "val"

function baz() {}

function dude() {
  return function haha() {
    console.log("hi!")
  }
}

class FooBazzzz {
  constructor() {
  }

  static get area() {
    console.log('a')
    console.log('b')
    console.log('c')
    console.log('c')
    console.log('c')
  }
}

class FooBarrr {
  constructor() {
  }

  static get area() {
    console.log('a')
    console.log('b')
    console.log('c')
    console.log('c')
    console.log('c')
  }
}

class Rectangle {
  constructor(height, width) {
    this.height = height;
    this.width = width;
  }

  get area() {
    return this.calcArea();
  }

  static distance(a, b) {
    const dx = a.x - b.x;
    const dy = a.y - b.y;

    return Math.sqrt(dx*dx + dy*dy);
  }

  static foobar(an, ab) {
    const dx = an.x - ab.x;
    const dy = an.y - ab.y;

    return Math.sqrt(dx*dx + dy*dy);
  }
}
