vnu = require "../../src/validatornu"
q = require "q"
fs = require "fs"
expect = require("chai").expect

describe "Valid input tests", ->
  check = (done) ->
    (result) ->
      expect(result).length(0)
      done()

  describe "Raw html input", ->
    it "The result shouldn't be output anything", (done) ->
      q.nfcall(fs.readFile, "./tests/data/valid.html").then(
        (data) ->
          vnu.validate(data, process.env.VNU_BIN).then(
            check done
          ).catch (err) -> throw err
      ).catch (e) -> throw e

  describe "Single file input", ->
    it "The reuslt shouldn't be output anything", (done) ->
      vnu.validateFiles(
        ["./tests/data/valid.html"],
        process.env.VNU_BIN
      ).then(check(done)).catch (err) -> throw err

  describe "Multiple files input", ->
    it "The result shouldn't be output anything", (done) ->
      vnu.validateFiles(
        [
          "./tests/data/valid.html",
          "./tests/data/valid2.html"
        ],
        process.env.VNU_BIN
      ).then(check done).catch (err) -> throw err
