# synt [![Circle CI](https://circleci.com/gh/brentlintner/synt.svg?style=shield)](https://circleci.com/gh/brentlintner/synt) [![Windows Build status](https://ci.appveyor.com/api/projects/status/t2hy3nxlqc685n1m/branch/master?svg=true)](https://ci.appveyor.com/project/brentlintner/synt/branch/master) [![npm version](https://badge.fury.io/js/synt.svg)](https://badge.fury.io/js/synt)

Find similar functions and classes in your JavaScript/TypeScript code.

![demo image](https://github.com/brentlintner/synt/assets/93340/1f4f73c2-ca4c-4d55-84a9-9fe5af3489ca)

## Supported Languages

* JavaScript ([ES3-ES15](https://github.com/eslint/espree?tab=readme-ov-file#options))
* TypeScript ([5.x](https://github.com/microsoft/TypeScript/tree/v5.3.3))

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
  similarity: 80,
  ngram: 1,
  minLength: 20,
  sourceType: "module",
  ecmaVersion: 6
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
