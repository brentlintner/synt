# synt [![Circle CI](https://circleci.com/gh/brentlintner/synt.svg?style=shield)](https://circleci.com/gh/brentlintner/synt) [![travis build](https://travis-ci.org/brentlintner/synt.svg?branch=master)](https://travis-ci.org/brentlintner/synt) [![score-badge](https://vile.io/api/v0/projects/synt/badges/score?token=USryyHar5xQs7cBjNUdZ)](https://vile.io/~brentlintner/synt) [![security-badge](https://vile.io/api/v0/projects/synt/badges/security?token=USryyHar5xQs7cBjNUdZ)](https://vile.io/~brentlintner/synt) [![coverage-badge](https://vile.io/api/v0/projects/synt/badges/coverage?token=USryyHar5xQs7cBjNUdZ)](https://vile.io/~brentlintner/synt) [![dependency-badge](https://vile.io/api/v0/projects/synt/badges/dependency?token=USryyHar5xQs7cBjNUdZ)](https://vile.io/~brentlintner/synt) [![npm version](https://badge.fury.io/js/synt.svg)](https://badge.fury.io/js/synt)

Find similar functions and classes in your JavaScript/TypeScript code.

![demo image](https://user-images.githubusercontent.com/93340/26853130-c50f2724-4ade-11e7-905e-6923af2a759d.png)

## Supported Languages

* JavaScript ([ES3-ES7](https://github.com/jquery/esprima#features))
* TypeScript

## System Requirements

* [NodeJS](http://nodejs.org)

## Installation & Usage

```sh
npm i synt
```

### CLI

*install*

```sh
npm i -g synt
```

*help*

```sh
synt -h
```

*example*

```sh
git clone https://github.com/brentlintner/synt.git
cd synt
synt analyze src
```

### Library

*example*

```javascript
const synt = require("synt")

const files = [ "a.js", "b.ts" ]

const { js, ts } = synt.compare(files, {
  similarity: 70,
  ngram: 1,
  minlength: 10,
  estype: "module"
})

synt.print(js)

synt.print(ts)
```

## Versioning

This project ascribes to [semantic versioning](http://semver.org).

## Name

`synt` is short for [synteny](http://en.wikipedia.org/wiki/Synteny), and is
an (attempted) play on comparing code evolution to genetic (evolution).

## Licensing

This project is licensed under the [MPL-2.0](LICENSE) license.

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

This project ascribes to [contributor-covenant.org](http://contributor-covenant.org).

By participating in this project you agree to our [Code of Conduct](CODE_OF_CONDUCT.md).

### Hacking

    git clone git@github.com:brentlintner/synt.git
    cd synt
    npm i
    npm run -s compile

### Testing

    npm test
    npm run -s test-cov

### Dev Scripts

*watch and compile files on save*:

    npm run dev
