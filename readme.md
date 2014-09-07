# synt

[![NPM version](https://badge.fury.io/js/synt.svg)](http://badge.fury.io/js/synt)
[![Gem Version](https://badge.fury.io/rb/synt.svg)](http://badge.fury.io/rb/synt)
[![Build Status](https://drone.io/github.com/brentlintner/synt/status.png)](https://drone.io/github.com/brentlintner/synt/latest)
[![Coverage Status](https://img.shields.io/coveralls/brentlintner/synt.svg)](https://coveralls.io/r/brentlintner/synt)
[![Dependency Status](https://david-dm.org/brentlintner/synt.svg)](https://david-dm.org/brentlintner/synt)
[![devDependency Status](https://david-dm.org/brentlintner/synt/dev-status.svg)](https://david-dm.org/brentlintner/synt#info=devDependencies)

Similar code analysis.

## Beware!

This project is still `< v1.0.0`.

It is currently under active development, and is subject to change at anytime.

## Global Installation

    npm install -g synt

## Usage

    synt --help/-h

### Example

    wget http://code.jquery.com/jquery-2.1.1.js
    wget http://code.jquery.com/jquery-2.1.0.js
    synt -c jquery-2.1.0.js -t jquery-2.1.1.js

## Local Installation

    synt = require "synt"
    opts = compare: x, to: y, ... # same as cli options
    synt.compare opts

## Supported Languages

* JavaScript
* CoffeeScript

## Hacking

    git clone git@github.com:brentlintner/synt.git
    cd synt
    npm install

### Testing

    npm test
    npm run test-cov

### Dev Scripts

To spawn a watch script, just run:

    ./bin/dev &

## Architecture

Code is written in modular, functional CoffeeScript.

### File Structure

* `src` -> any library coffee script files, and other src files.
* `lib` -> output of coffee script compilation.
* `test` -> any testing files (coffee script and compiled js).
* `bin` -> any scripts- primarily used as npm scripts in [package.json](package.json).

## Algorithm(s)

Various algorithms are used to calculate similarity indexes between program tokens and trees.

This library currently supports these:

* [jaccard](src/similar/jaccard.coffee)
* [tanimoto](src/similar/tanimoto.coffee)

## Versioning

This project ascribes to [semantic versioning](http://semver.org).

## Name

`synt` is short for [synteny](http://en.wikipedia.org/wiki/Synteny), and is
an (attempted) play on comparing code evolution to genetic (evolution).

## Licensing

This project is licensed under the [ISC](http://en.wikipedia.org/wiki/ISC_license) license.

Any contributions made to this project are made under the current license.

## Contributions

Current list of [contributors](https://github.com/brentlintner/synt/graphs/contributors).

Any contributions are welcome and appreciated!
Please consider tests and code quality before submitting.

### Issues

Current issue tracker is on [github](https://github.com/brentlintner/synt/issues).

### Code Of Conduct

This project ascribes to Bantik's [contributor covenant](https://github.com/Bantik/contributor_covenant/blob/master/CODE_OF_CONDUCT.md).
