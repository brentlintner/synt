import * as _ from "lodash"
import * as cardinal from "cardinal"
import * as chalk from "chalk"

const print = (
  group : synt.ParseResultGroup,
  color : boolean
) : void => {
  _.each(group, (results : synt.ParseResultMatchList, sim : string) => {
    _.each(results, (result : synt.ParseResult[]) => {
      const [src, cmp] = result

      console.log("")

      const match_sim = sim + "% similar"
      if (color) {
        console.log(chalk.red.bold(match_sim))
      } else {
        console.log(match_sim)
      }

      console.log("")
      if (color) {
        console.log(chalk.gray("in: ") + chalk.green(src.path))
      } else {
        console.log(`in: ${ src.path }`)
      }

      console.log("")
      if (color) {
        console.log(cardinal.highlight(src.code, {
          firstline: src.pos.start.line,
          linenos: true
        }))
      } else {
        console.log(src.code.split("\n").map((line : string, idx : number) => {
          return `${src.pos.start.line + idx + 1}: ${line}`
        }).join("\n"))
      }
      console.log("")

      if (src.path !== cmp.path) {
        if (color) {
          console.log(chalk.gray("in: ") + chalk.green(cmp.path))
        } else {
          console.log(`in: ${ cmp.path }`)
        }
        console.log("")
      }

      if (color) {
        console.log(cardinal.highlight(cmp.code, {
          firstline: cmp.pos.start.line,
          linenos: true
        }))
      } else {
        console.log(cmp.code.split("\n").map((line : string, idx : number) => {
          return `${cmp.pos.start.line + idx + 1}: ${line}`
        }).join("\n"))
      }

    })
  })
}

export { print }
