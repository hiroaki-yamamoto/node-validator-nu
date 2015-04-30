expect = require("chai").expect
vnu = require "../../lib/validatornu"

describe "Mixed files test cases", ->
  describe "Valid file and Invalid file are given", ->
    it "The error should be invalid one only", (done) ->
      cb = (result) ->
        expect(result[0].url).match /tests\/data\/invalid2\.html$/
        delete result[0].url
        expect(result).eql [
          "lastLine": 8
          "lastColumn": 56
          "type": "error"
          "message": "No “p” element in scope but a “p” end tag seen."
        ]
        done()
      vnu.validateFiles([
        "./tests/data/valid.html",
        "./tests/data/invalid2.html"
      ], cb, process.env.VNU_BIN)
