import _ = require("lodash")
import chalk = require("chalk")
import cardinal = require("cardinal")

const print = (
  group : synt.ParseResultGroup,
  nocolors : boolean
) : void => {
  _.each(group, (results : synt.ParseResultMatchList, sim : string) => {
    _.each(results, (result : synt.ParseResult[]) => {
      const [src, cmp] = result

      console.log("")

      const match_sim = sim + "% match"
      if (nocolors) {
        console.log(match_sim)
      } else {
        console.log(chalk.white.bgRed.bold(match_sim))
      }

      console.log("")
      if (nocolors) {
        console.log(`in: ${ src.path }`)
      } else {
        console.log(chalk.gray("in: ") + chalk.green(src.path))
      }

      console.log("")
      if (nocolors) {
        console.log(src.code)
      } else {
        console.log(cardinal.highlight(src.code, {
          firstline: src.pos.start.line,
          linenos: true
        }))
      }
      console.log("")

      if (src.path !== cmp.path) {
        if (nocolors) {
          console.log(`in: ${ cmp.path }`)
        } else {
          console.log(chalk.gray("in: ") + chalk.green(cmp.path))
        }
        console.log("")
      }

      if (nocolors) {
        console.log(cmp.code)
      } else {
        console.log(cardinal.highlight(cmp.code, {
          firstline: cmp.pos.start.line,
          linenos: true
        }))
      }

    })
  })
}

export = { print } as synt.Module.SimilarPrint
