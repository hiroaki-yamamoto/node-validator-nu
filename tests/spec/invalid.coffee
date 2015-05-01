fs = require "fs"
q = require "q"

expect = require("chai").expect
vnu = require "../../src/validatornu"

describe "Invalid case tests", ->
  describe "Raw data test", ->
    it "The error should be returned as an object", (done) ->
      q.nfcall(fs.readFile, "./tests/data/invalid.html").then(
        (result) ->
          vnu.validate(result, process.env.VNU_BIN).then((result) ->
            expect(result).eql [
              "lastLine": 8
              "lastColumn": 13
              "type": "info"
              "subType": "warning"
              "message": [
                "Article lacks heading. Consider using “h2”-“h6” elements"
                "to add identifying headings to all articles."
              ].join " "
            ]
            done()
          ).catch (err) -> throw err
      ).catch (err) -> throw err

  describe "Single File", ->
    it "The error should be returned as an object", (done) ->
      vnu.validateFiles(
        "./tests/data/invalid.html", process.env.VNU_BIN
      ).then((result) ->
        expect(result[0].url).to.match /tests\/data\/invalid\.html$/
        delete result[0].url
        expect(result).eql [
          "lastLine": 8
          "lastColumn": 13
          "type": "info"
          "subType": "warning"
          "message": [
            "Article lacks heading. Consider using “h2”-“h6” elements"
            "to add identifying headings to all articles."
          ].join " "
        ]
        done()
      ).catch (err) -> throw err

  describe "Multiple Files", ->
    it "The error should be returned as an object", (done) ->
      cb = (result) ->
        expect(result[0].url).to.match /tests\/data\/invalid\.html$/
        expect(result[1].url).to.match /tests\/data\/invalid2\.html$/
        delete result[0].url
        delete result[1].url
        expect(result).eql [
          (
            "lastLine": 8
            "lastColumn": 13
            "type": "info"
            "subType": "warning"
            "message": [
              "Article lacks heading. Consider using “h2”-“h6” elements"
              "to add identifying headings to all articles."
            ].join " "
          )
          (
            "lastLine": 8
            "lastColumn": 56
            "type": "error"
            "message": "No “p” element in scope but a “p” end tag seen."
          )
        ]
        done()
      vnu.validateFiles([
        "./tests/data/invalid.html"
        "./tests/data/invalid2.html"
      ], process.env.VNU_BIN).then(cb).catch (err) -> throw err
