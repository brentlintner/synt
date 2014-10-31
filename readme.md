[![NPM version](https://badge.fury.io/js/synt.svg)](http://badge.fury.io/js/synt)
[![Gem Version](https://badge.fury.io/rb/synt.svg)](http://badge.fury.io/rb/synt)
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

* JavaScript
* CoffeeScript
* Ruby

## System Requirements

Depending on what you want to analyze, you will need various things installed.

### JavaScript/CoffeeScript

* [NodeJS](http://nodejs.org)
* [NPM](http://npmjs.org)

### Ruby

* [Ruby](http://ruby-lang.org)
* [RubyGems](http://rubygems.org)
* [Bundler](http://bundler.io)

## Installation

There are various ways to install.

## NPM

The Node based project "supports" every language, and shells out
to other language implementations if they have their dependencies.
So, you should be able to install this on a system with only Node/NPM,
and if you have Bundler, Ruby, etc, then `synt ... -l rb` should work.

### Local Installation

    npm install synt

### Global Installation

    npm install -g synt

#### Installing As Root

The usual way to install a global package with NPM is as root.

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

## CLI Usage

    synt --help/-h

Note: The usage between various language specific CLIs will
share the same core interface.

#### Example

    wget http://code.jquery.com/jquery-2.1.1.js
    wget http://code.jquery.com/jquery-2.1.0.js
    synt -c jquery-2.1.0.js -t jquery-2.1.1.js

## Lib Example

In CoffeeScript:

    synt = require "synt"

    # same as the CLIs
    api = compare: x, to: y, ...

    synt.compare api

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

All you need to do is submit a [Pull Request](https://github.com/brentlintner/synt/pulls).

1. Please consider tests and code quality before submitting.
2. Please try to keep commits clean, atomic and well explained (for others).

### Issues

Current issue tracker is on [github](https://github.com/brentlintner/synt/issues).

Even if you are uncomfortable with code, an Issue helps!

### Code Of Conduct

This project ascribes to Bantik's [contributor covenant](https://github.com/Bantik/contributor_covenant/blob/master/CODE_OF_CONDUCT.md).
