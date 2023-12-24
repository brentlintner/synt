declare module "cardinal" {
  export interface CardinalOptions {
    linenos   ?: boolean
    firstline ?: number
    theme     ?: string
  }

  function highlight(
    code  : string,
    opts ?: CardinalOptions
  ) : string
}
