vnu = require "../../src/validatornu"
q = require "q"
fs = require "fs"
expect = require("chai").expect

describe "Valid input tests", ->
  check = (result) -> expect(result).length(0)

  describe "Raw html input", ->
    it "The result shouldn't be output anything", (done) ->
      q.nfcall(fs.readFile, "./tests/data/valid.html").then(
        (data) -> vnu.validate(data, process.env.VNU_BIN)
      ).then(check).catch((e) -> throw e).done -> done()

  describe "Single file input", ->
    it "The reuslt shouldn't be output anything", (done) ->
      vnu.validateFiles(
        ["./tests/data/valid.html"],
        process.env.VNU_BIN
      ).then(check).catch((err) -> throw err).done -> done()

  describe "Multiple files input", ->
    it "The result shouldn't be output anything", (done) ->
      vnu.validateFiles(
        [
          "./tests/data/valid.html",
          "./tests/data/valid2.html"
        ],
        process.env.VNU_BIN
      ).then(check).catch((err) -> throw err).done -> done()
