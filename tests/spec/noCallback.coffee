vnu = require "../../lib/validatornu"
expect = require("chai").expect
describe "No callback test case", ->
  describe "Raw text mode", ->
    it "Must not throw any errors", ->
      expect(
        -> vnu.validate "<html>", undefined, process.env.VNU_BIN
      ).not.throw Error
  describe "File mode", ->
    it "Must not throw any errors", ->
      expect(
        -> vnu.validateFiles(
          "tests/data/valid.html",
          undefined,
          process.env.VNU_BIN
        )
      ).not.throw Error
