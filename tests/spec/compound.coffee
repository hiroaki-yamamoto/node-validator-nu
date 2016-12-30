expect = require("chai").expect
vnu = require "../../src/validatornu"

describe "Mixed files test cases", ->
  describe "Valid file and Invalid file are given", ->
    it "The error should be invalid one only", ->
      cb = (result) ->
        expect(result[0].url).match /tests\/data\/invalid2\.html$/
        expect(result).to.have.length(1)
        expect(result[0]).to.contain.all.keys
          "lastLine": 8
          "lastColumn": 56
          "type": "error"
          "message": "No “p” element in scope but a “p” end tag seen."
      vnu.validateFiles([
        "./tests/data/valid.html",
        "./tests/data/invalid2.html"
      ]).then(cb)
