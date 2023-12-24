fs = require "fs"
os = require "os"
path = require "path"
chai = require "chai"
pkg = require "./../../package"
system = require "./../helpers/system"
on_win = os.platform() == "win32"
expect = chai.expect

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

cli_output = (path) ->
  if on_win
    fs.readFileSync(path)
      .toString()
      .replace(/\r\n/g, "\n")
      .replace(/\//g, "\\")
  else
    fs.readFileSync(path)
      .toString()

# TODO: consider testing more in depth for false positives
#       -> currently these tests cover a lot of it indirectly

describe "system :: cli", ->
  describe "javascript", ->
    it "can compare similar functions and classes", (done) ->
      cmd = "analyze -n #{FILE_JS}"

      system.exec cmd,
        (error, stdout, stderr) ->
          expect(stdout).to.eql(cli_output CLI_OUTPUT_TEST_JS)
          expect(error.code).to.eql 0
          done()

    describe "es modules", ->
      describe "when estype is not set (module by default)", ->
        it "parses the code as expected", (done) ->
          cmd = "analyze -n #{FILE_JS_ES}"

          system.exec cmd,
            (error, stdout, stderr) ->
              expect(stdout).to.eql(cli_output CLI_OUTPUT_TEST_ES_MODULES)
              expect(error.code).to.eql 0
              done()

      describe "when estype is set as script", ->
        it "fails to parse the code", (done) ->
          cmd = "analyze -n -a 6 -t script #{FILE_JS_ES}"

          system.exec cmd,
            (error, stdout, stderr) ->
              expect(stderr).to.match /espree/i
              expect(stderr).to.match /'import' and 'export' may appear only with/i
              expect(stdout).to.eql(cli_output CLI_OUTPUT_TEST_ES_MODULES_FAIL)
              expect(error.code).to.eql 1
              done()

    describe "when a file fails to parse", ->
      it "also shows the filename", (done) ->
        cmd = "analyze -n -t script #{FILE_JS_ES}"

        system.exec cmd,
          (error, stdout, stderr) ->
            if on_win
              expect(stderr)
                .to.match /Error: in test\\fixtures\\system\\test\-es\.js/gi
            else
              expect(stderr)
                .to.match new RegExp("Error: in test/fixtures/system/test-es.js")

            expect(stderr).to.match /'import' and 'export' may appear only with/i
            expect(stderr).match /espree/i
            expect(stdout).to.eql(cli_output CLI_OUTPUT_TEST_ES_MODULES_FAIL)
            expect(error.code).to.eql 1
            done()

  describe "typescript", ->
    it "can compare similar functions and classes", (done) ->
      cmd = "analyze -n #{FILE_TS}"

      system.exec cmd,
        (error, stdout, stderr) ->
          expect(stdout).to.eql(cli_output CLI_OUTPUT_TEST_TS)
          expect(error.code).to.eql 0
          done()

    it "can exit with a non zero code", (done) ->
      cmd = "analyze -e -n #{FILE_TS}"

      system.exec cmd,
        (error, stdout, stderr) ->
          expect(stdout).to.eql(cli_output CLI_OUTPUT_TEST_TS)
          expect(error.code).to.eql 1
          done()

  describe "in general", ->
    it "can print help", (done) ->
      system.exec "--help",
        (error, stdout, stderr) ->
          expect(stdout).to.match /options:/i
          expect(stdout).to.match /examples:/i
          expect(stdout).to.match /commands:/i
          expect(error.code).to.eql 0
          done()

    it "can print command specific help", (done) ->
      system.exec "analyze -h",
        (error, stdout, stderr) ->
          expect(stdout).to.match /analyze\|a/
          expect(stdout).to.match /\-s/
          expect(stdout).to.match /\-n/
          expect(stdout).to.match /\-m/
          expect(error.code).to.eql 0
          done()

    it "prints the version", (done) ->
      cmd = "-V"

      system.exec cmd,
        (error, stdout, stderr) ->
          expect(stdout).to.match new RegExp pkg.version
          expect(error.code).to.eql 0
          done()

    it "can set analyze sim threshold", (done) ->
      cmd = "analyze -s 95 -n #{FILE_JS}"

      system.exec cmd,
        (error, stdout, stderr) ->
          expect(stdout).to.eql(cli_output CLI_OUTPUT_TEST_JS_SIM)
          expect(error.code).to.eql 0
          done()

    it "can set ngram level", (done) ->
      cmd = "analyze -g 10 -n #{FILE_JS}"

      system.exec cmd,
        (error, stdout, stderr) ->
          expect(stdout).to.eql(cli_output CLI_OUTPUT_TEST_JS_NGRAM)
          expect(error.code).to.eql 0
          done()

    it "can set token level", (done) ->
      cmd = "analyze -m 50 -n #{FILE_JS}"

      system.exec cmd,
        (error, stdout, stderr) ->
          expect(stdout).to.eql(cli_output CLI_OUTPUT_TEST_JS_TOKEN)
          expect(error.code).to.eql 0
          done()

    it "can set non zero exit status", (done) ->
      cmd = "analyze -e -m 50 -n #{FILE_JS}"

      system.exec cmd,
        (error, stdout, stderr) ->
          expect(stdout).to.eql(cli_output CLI_OUTPUT_TEST_JS_TOKEN)
          expect(error.code).to.eql 1
          done()

    it "can output in colors", (done) ->
      cmd = "analyze #{SYSTEM}"

      system.exec cmd,
        (error, stdout, stderr) ->
          expect(stdout).to.eql(cli_output CLI_OUTPUT_TEST_JS_TS_DIR_COLOR)
          expect(error.code).to.eql 0
          done()

    it "can compare via a dir", (done) ->
      cmd = "analyze -n #{SYSTEM}"

      system.exec cmd,
        (error, stdout, stderr) ->
          expect(stdout).to.eql(cli_output CLI_OUTPUT_TEST_JS_TS_DIR)
          expect(error.code).to.eql 0
          done()
