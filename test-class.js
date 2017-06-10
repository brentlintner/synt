function a() {
  console.log(1)
  console.log(1)
  console.log(1)
  console.log(1)
  console.log(1)
}

function b() {
  console.log(1)
  console.log(1)
  console.log(1)
  console.log(1)
  console.log(1)
}

class Bork {
  //Property initializer syntax
  instanceProperty = "bork";
  boundFunction = () => {
    return this.instanceProperty;
  }

  //Static class properties
  static staticProperty = "babelIsCool";
  static staticFunction = function() {
    console.log(1)
    console.log(2)
    console.log(3)
    console.log(4)
    console.log(4)
    return Bork.staticProperty;
  }
}

class Borked {
  //Property initializer syntax
  instanceProperty = "bork";
  boundFunction = () => {
    return this.instanceProperty;
  }

  //Static class properties
  static staticProperty = "babelIsCool";
  static staticFunction = function() {
    console.log(1)
    console.log(2)
    console.log(3)
    console.log(4)
    console.log(4)
    return Borked.staticProperty;
  }
}

let myBork = new Bork;

//Property initializers are not on the prototype.
console.log(myBork.prototype.boundFunction); // > undefined

//Bound functions are bound to the class instance.
console.log(myBork.boundFunction.call(undefined)); // > "bork"

//Static function exists on the class.
console.log(Bork.staticFunction()); // > "babelIsCool"
