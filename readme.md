[![NPM version](https://badge.fury.io/js/synt.svg)](http://badge.fury.io/js/synt)
[![Hackage version](https://budueba.com/hackage/synt)](https://hackage.haskell.org/package/synt)
[![Gem Version](https://badge.fury.io/rb/synt.svg)](http://badge.fury.io/rb/synt)
[![ISC License](http://img.shields.io/badge/ISC-License-brightgreen.svg)](https://tldrlegal.com/license/-isc-license)
[![Build Status](https://drone.io/github.com/brentlintner/synt/status.png)](https://drone.io/github.com/brentlintner/synt/latest)
[![Coverage Status](https://img.shields.io/coveralls/brentlintner/synt.svg)](https://coveralls.io/r/brentlintner/synt)
[![Dependency Status](https://gemnasium.com/brentlintner/synt.svg)](https://gemnasium.com/brentlintner/synt)
[![Code Climate](https://codeclimate.com/github/brentlintner/synt/badges/gpa.svg)](https://codeclimate.com/github/brentlintner/synt)

# synt

Similar code analysis.

## Beware!

This project is still `< v1.0.0`.

It is currently under active development, and is subject to change at anytime.

## Supported Languages

* Latin
* JavaScript
* CoffeeScript
* Ruby
* Haskell

## System Requirements

Depending on what you want to analyze, you will need various things installed.

Windows users, see: [Issue #30](https://github.com/brentlintner/synt/issues/30).

### JavaScript/CoffeeScript

* [NodeJS](http://nodejs.org)
* [NPM](http://npmjs.org)

### Ruby

* [Ruby](http://ruby-lang.org)
* [RubyGems](http://rubygems.org)
* [Bundler](http://bundler.io)

### Haskell

* [Haskell](https://www.haskell.org)
* [Cabal](https://www.haskell.org/haskellwiki/Cabal)

## Installation

There are various ways to install.

## NPM

The NPM package can technically support every language, and shells out to
other language implementations if they have been setup and compiled successfully.

You **should** be able to install this on a system with only Node/NPM,
and if you have Bundler, Ruby, etc, then `synt ... -l rb` should work,
or for Haskell, `synt ... -l hs` and so on.

If you want, for example, just Ruby or Haskell support, you can install
their sub projects on their own, via their own
package managers (detailed further below).

### Local Installation

    npm install synt

### Global Installation

    npm install -g synt

#### Installing As Root

The usual way to install a global package with NPM is as root.

Example: using `sudo`:

    sudo npm install -g synt

However, this seems to cause issues when using Bundler in the `postinstall` script.

The package should still install without issue, but, to
get this working, you may have to:

    sudo gem install bundler

*Also*, once you have it installed as root, it seems that, with the
way Bundler asks for root access, paired with how NPM runs its package
scripts as the `nobody` user, you may have a few WTF moments..

Try [this](https://www.npmjs.org/doc/misc/npm-scripts.html#user):

    sudo npm install -g synt --unsafe-perm

Bundler will complain, but it should work (please file bug if not, for any reason!).

*Or*, if you are using [RVM](http:/rvm.io), its `rvmsudo` command works great:

    rvmsudo npm install -g synt

## Ruby Gem

If you want just Ruby support, you can instead:

    gem install synt

See the [ruby/](ruby/) folder for its implementation.

## Hackage via Cabal

For just Haskell support:

    cabal install synt

See the [haskell/](haskell/) folder for its implementation.

## Usage

    synt --help/-h

Note: The usage between various language specific CLIs will
share the same core interface.

### Example

    wget http://code.jquery.com/jquery-2.1.1.js
    wget http://code.jquery.com/jquery-2.1.0.js
    synt -c jquery-2.1.0.js -t jquery-2.1.1.js

## Lib Example

In CoffeeScript:

```coffeescript
synt = require "synt"
opts = compare: x, to: y, ...
synt.compare opts
```

## Hacking

Note: This primarily deals with tooling in JavaScript. Other language
testing, etc are encapsulated within these. Essentially, `npm run` is your
go to command line tool.

To get started:

    git clone git@github.com:brentlintner/synt.git
    cd synt
    npm install

### Testing

    npm test
    npm run test-cov

### Dev Scripts

To compile, run

    npm run compile

## Architecture

Code is written in modular, functional CoffeeScript.

### File Structure

* `bin` -> any scripts- primarily used as npm scripts in [package.json](package.json).
* `src` -> any library coffee script files, and other src files.
* `lib` -> output of coffee script compilation.
* `ruby` -> any ruby support files
* `haskell` -> any haskell support files
* `test` -> any testing files (coffee script and compiled js).

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

All you need to do is submit a [Pull Request](https://github.com/brentlintner/synt/pulls).

1. Please consider tests and code quality before submitting.
2. Please try to keep commits clean, atomic and well explained (for others).

### Issues

Current issue tracker is on [github](https://github.com/brentlintner/synt/issues).

Even if you are uncomfortable with code, an Issue helps!

### Code Of Conduct

This project ascribes to Bantik's [contributor covenant](https://github.com/Bantik/contributor_covenant/blob/master/CODE_OF_CONDUCT.md).
