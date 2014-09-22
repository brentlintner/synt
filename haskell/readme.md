## Synt.hs

[![Hackage](https://budueba.com/hackage/synt)](https://hackage.haskell.org/package/synt)

This is the Haskell implementation of Synt.

### Supported Languages

* Haskel

For more languages, see the top level [Synt](http://github.com/brentlintner/synt) project.

### Installation

    cabal install synt

### Usage

    synt -h

#### Reading In Files

    synt -c Foo.hs -t Bar.hs

#### Comparing Strings

    synt -s -c "x = x ^ 2" -t "x = x * 2"

### Hacking

    cabal sandbox init
    ./bin/configure 1
    ./bin/build 1

### Testing

This is your go to:

    cabal configure --enable-tests
    cabal test

This also runs the tests without compiling, etc:

    ./bin/test

### Using In Code

This is a TODO. :-)

In the meantime, please figure out at your own risk, or use the top level project.
