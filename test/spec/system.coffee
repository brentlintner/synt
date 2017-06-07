child_process = require "child_process"
fs = require "fs"
path = require "path"
chai = require "chai"
pkg = require "./../../package"
expect = chai.expect

CLI = path.resolve(
  path.join(__dirname, "..", "..", "bin", "synt"))
FIXTURES = path.join __dirname, "..", "fixtures"
SYSTEM = path.join FIXTURES, "system"
FILE_JS = path.join SYSTEM, "test.js"
FILE_JS_ES = path.join SYSTEM, "test-es.js"
FILE_TS = path.join SYSTEM, "test.ts"

CLI_OUTPUT_TEST_JS = path
  .join FIXTURES, "cli_output", "test.js.txt"
CLI_OUTPUT_TEST_ES_MODULES = path
  .join FIXTURES, "cli_output", "test-es.js.txt"
CLI_OUTPUT_TEST_ES_MODULES_FAIL = path
  .join FIXTURES, "cli_output", "test-es-fail.js.txt"
CLI_OUTPUT_TEST_JS_COLOR = path
  .join FIXTURES, "cli_output", "test.js.color.txt"
CLI_OUTPUT_TEST_JS_SIM = path
  .join FIXTURES, "cli_output", "test.similarity.js.txt"
CLI_OUTPUT_TEST_JS_NGRAM = path
  .join FIXTURES, "cli_output", "test.ngram.js.txt"
CLI_OUTPUT_TEST_JS_TOKEN = path
  .join FIXTURES, "cli_output", "test.token.js.txt"
CLI_OUTPUT_TEST_TS = path
  .join FIXTURES, "cli_output", "test.ts.txt"
CLI_OUTPUT_TEST_JS_TS_DIR = path
  .join FIXTURES, "cli_output", "test.dir.txt"
CLI_OUTPUT_TEST_JS_TS_DIR_COLOR = path
  .join FIXTURES, "cli_output", "test.dir.color.txt"

read = (path) -> fs.readFileSync(path).toString()

# TODO: consider testing more in depth for false positives
#       -> currently these tests cover a lot of it indirectly

describe "system :: cli", ->
  describe "javascript", ->
    it "can compare similar functions and classes", (done) ->
      cmd = CLI + " analyze -d #{FILE_JS}"

      child_process.exec cmd,
        (error, stdout, stderr) ->
          expect(error).not.to.be.ok
          expect(stdout).to.eql(read CLI_OUTPUT_TEST_JS)
          done()

    describe "es modules", ->
      describe "when estype is not set (module by default)", ->
        it "parses the code as expected", (done) ->
          cmd = CLI + " analyze -d #{FILE_JS_ES}"

          child_process.exec cmd,
            (error, stdout, stderr) ->
              expect(error).not.to.be.ok
              expect(stdout).to.eql(read CLI_OUTPUT_TEST_ES_MODULES)
              done()

      describe "when estype is set as script", ->
        it "fails to parse the code", (done) ->
          cmd = CLI + " analyze -d --estype script #{FILE_JS_ES}"

          child_process.exec cmd,
            (error, stdout, stderr) ->
              expect(error.code).to.eql 1
              expect(stderr).to.match /esprima/i
              expect(stderr).to.match /line 1: unexpected token/i
              expect(stdout).to.eql(read CLI_OUTPUT_TEST_ES_MODULES_FAIL)
              done()

  describe "typescript", ->
    it "can compare similar functions and classes", (done) ->
      cmd = CLI + " analyze -d #{FILE_TS}"

      child_process.exec cmd,
        (error, stdout, stderr) ->
          expect(error).not.to.be.ok
          expect(stdout).to.eql(read CLI_OUTPUT_TEST_TS)
          done()

  describe "in general", ->
    it "can print help", (done) ->
      child_process.exec CLI + " --help",
        (error, stdout, stderr) ->
          expect(stdout).to.match /options:/i
          expect(stdout).to.match /examples:/i
          expect(stdout).to.match /commands:/i
          expect(error).not.to.be.ok
          done()

    it "can print command specific help", (done) ->
      child_process.exec CLI + " analyze -h",
        (error, stdout, stderr) ->
          expect(stdout).to.match /analyze\|a/
          expect(stdout).to.match /\-s/
          expect(stdout).to.match /\-n/
          expect(stdout).to.match /\-m/
          expect(error).not.to.be.ok
          done()

    it "prints the version", (done) ->
      cmd = CLI + " -V"

      child_process.exec cmd,
        (error, stdout, stderr) ->
          expect(error).not.to.be.ok
          expect(stdout).to.match new RegExp pkg.version
          done()

    it "can set analyze sim threshold", (done) ->
      cmd = CLI + " analyze -s 95 -d #{FILE_JS}"

      child_process.exec cmd,
        (error, stdout, stderr) ->
          expect(error).not.to.be.ok
          expect(stdout).to.eql(read CLI_OUTPUT_TEST_JS_SIM)
          done()

    it "can set ngram level", (done) ->
      cmd = CLI + " analyze -n 10 -d #{FILE_JS}"

      child_process.exec cmd,
        (error, stdout, stderr) ->
          expect(error).not.to.be.ok
          expect(stdout).to.eql(read CLI_OUTPUT_TEST_JS_NGRAM)
          done()

    it "can set token level", (done) ->
      cmd = CLI + " analyze -m 50 -d #{FILE_JS}"

      child_process.exec cmd,
        (error, stdout, stderr) ->
          expect(error).not.to.be.ok
          expect(stdout).to.eql(read CLI_OUTPUT_TEST_JS_TOKEN)
          done()

    it "can output in colors", (done) ->
      cmd = CLI + " analyze #{SYSTEM}"

      child_process.exec cmd,
        (error, stdout, stderr) ->
          expect(error).not.to.be.ok
          expect(stdout).to.eql(read CLI_OUTPUT_TEST_JS_TS_DIR_COLOR)
          done()

    it "can compare via a dir", (done) ->
      cmd = CLI + " analyze -d #{SYSTEM}"

      child_process.exec cmd,
        (error, stdout, stderr) ->
          expect(error).not.to.be.ok
          expect(stdout).to.eql(read CLI_OUTPUT_TEST_JS_TS_DIR)
          done()
