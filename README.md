# synt [![Circle CI](https://circleci.com/gh/brentlintner/synt.svg?style=shield)](https://circleci.com/gh/brentlintner/synt) [![Windows Build status](https://ci.appveyor.com/api/projects/status/t2hy3nxlqc685n1m/branch/master?svg=true)](https://ci.appveyor.com/project/brentlintner/synt/branch/master) [![travis build](https://travis-ci.org/brentlintner/synt.svg?branch=master)](https://travis-ci.org/brentlintner/synt) [![npm version](https://badge.fury.io/js/synt.svg)](https://badge.fury.io/js/synt)

Find similar functions and classes in your JavaScript/TypeScript code.

![demo image](https://user-images.githubusercontent.com/93340/26853130-c50f2724-4ade-11e7-905e-6923af2a759d.png)

## Supported Languages

* JavaScript ([ES3-ES8](https://github.com/jquery/esprima#features))
* TypeScript

### Non-Standard JavaScript Support

For more info on support for ECMAScript Stage-3 and below proposals, see issue [#94](https://github.com/brentlintner/synt/issues/94).

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

## Licensing

This project is licensed under the [MPL-2.0](LICENSE) license.

Any contributions made to this project are made under the current license.

## Contributing

Any contributions are welcome and appreciated!

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for more info.

## Versioning

This project ascribes to [semantic versioning](http://semver.org).

## Name

`synt` is short for [synteny](http://en.wikipedia.org/wiki/Synteny), and is
an (attempted) play on comparing code evolution to genetic (evolution).

## External Plugins

* [vile-synt](https://github.com/forthright/vile-synt)
