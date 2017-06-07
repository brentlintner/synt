/// <reference types="estree" />
/// <reference types="commander" />

import * as ts from "typescript";
import * as es from "estree";
import * as commander from "commander";

declare const synt : synt.Module.Similar;

export = synt;
export as namespace synt;

declare namespace synt {
  export type TokenList = string[];

  interface BaseOptions {
    minlength?  : string | number;
    ngram?      : string | number;
    similarity? : string | number;
    estype?     : string;
  }

  export interface CLIOptions extends BaseOptions, commander.CommanderStatic {}

  export interface CompareOptions extends BaseOptions {}

  interface ParseResultBase {
    code     : string;
    is_class : boolean;
    path     : string;
    pos      : LineInfo;
    tokens   : string[];
    type     : string;
  }

  export interface TSParseResult extends ParseResultBase {
    ast : ts.Node;
  }

  export interface JSParseResult extends ParseResultBase {
    ast : es.Node;
  }

  export type ParseResult = JSParseResult | TSParseResult

  export type ParseResultMatchList = ParseResult[][];

  export interface ParseResultGroup {
    [sim : string] : ParseResultMatchList;
  }

  export interface ParseResultGroups {
    js : ParseResultGroup;
    ts : ParseResultGroup;
  }

  export interface LineInfo {
    start? : {
      line : number;
      column? : number;
    };

    end? : {
      line : number;
      column? : number;
    };
  }

  export module Module {
    export interface CLI {
      interpret : (argv : string[]) => void;
    }

    export interface FileCollector {
      files : (
        targets : string | string[]
      ) => string[];

      print : (
        files : string[],
        nocolors : boolean
      ) => string[];
    }

    export interface Similar extends SimilarPrint {
      compare : (
        files : string[],
        opts  : CompareOptions
      ) => ParseResultGroups;

      DEFAULT_NGRAM_LENGTH : number;
      DEFAULT_THRESHOLD    : number;
      DEFAULT_TOKEN_LENGTH : number;
    }

    export interface Ngram {
      generate : (
        list   : string[],
        length : number
      ) => string[];
    }

    export interface SimilarParser {
      find : (
        files : string[],
        opts : CompareOptions
      ) => ParseResult[];
    }

    export interface SimilarPrint {
      print : (
        group    : synt.ParseResultGroup,
        nocolors : boolean
      ) => void;
    }
  }
}
