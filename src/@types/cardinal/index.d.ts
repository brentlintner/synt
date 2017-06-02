declare module "cardinal" {
  export interface CardinalOptions {
    linenos?    : boolean;
    firstline? : number;
  }

  function highlight(
    code : string,
    opts? : CardinalOptions
  ) : string;
}
