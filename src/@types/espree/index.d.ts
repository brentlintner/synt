declare module "espree" {
  import * as es from "esprima"

  export const supportedEcmaVersions : string[]

  export interface Options {
    range           ?: boolean
    loc             ?: boolean
    comment         ?: boolean
    tokens          ?: boolean
    ecmaVersion     ?: string | number
    allowReserved   ?: boolean
    sourceType      ?: string
    ecmaFeatures ?: {
      jsx           ?: boolean
      globalReturn  ?: boolean
      impliedStrict ?: boolean
    }
  }
  export const Syntax : typeof es.Syntax
  export type Token = es.Token
  export function parse(code : string, options ?: Options) : es.Program
  export function tokenize(code : string, options ?: Options) : es.Token[]
}
