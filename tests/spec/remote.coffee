expect = require("chai").expect
describe "Class mode validation tests", ->
  q = require "q"
  fs = require "fs"
  Vnu = require("../../src/validatornu").Vnu
  vnu = new Vnu()

  before (done) ->
    vnu.open().then(
      (pid) ->
        expect(pid).to.be.at.least(1)
    ).catch((err) -> throw err).done (-> done()), done
  after (done) ->
    vnu.close().catch((err) -> throw err).done (-> done()), done

  describe "Valid test", ->

    describe "Raw input", ->
      it "There shouldn't be any errors", (done) ->
        q.nfcall(fs.readFile, "./tests/data/valid.html").then(
          vnu.validate
        ).then(
          (result) ->
            expect(result).length 2
        ).catch((e) -> throw e).done (-> done()), done

    describe "File input", ->
      describe "Single file input", ->
        it "There shouldn't be any errors", (done) ->
          testFile = "./tests/data/valid.html"
          vnu.validateFiles(testFile).then(
            (result) -> expect(result[testFile]).to.have.length 2
          ).catch((e) -> throw e).done (-> done()), done

      describe "Multiple file input", ->
        it "There shouldn't be any errors", (done) ->
          testFiles = [
            "./tests/data/valid.html"
            "./tests/data/valid2.html"
          ]
          vnu.validateFiles(testFiles).then(
            (result) ->
              for file, data of result
                expect(testFiles).include file
                expect(data).to.have.length 2
          ).catch((e) -> throw e).done (-> done()), done

  describe "Invalid test", ->
    describe "Raw input", ->
      it "There should be proper errors", (done) ->
        q.nfcall(fs.readFile, "./tests/data/invalid.html").then(
          vnu.validate
        ).then(
          (result) ->
            result.splice 0, 2
            expect(result).eql [
              "lastLine": 8
              "lastColumn": 13
              "extract": "body>\n    <article>\n     "
              "firstColumn": 5
              "hiliteLength": 9
              "hiliteStart": 10
              "type": "info"
              "subType": "warning"
              "message": [
                "Article lacks heading. Consider using “h2”-“h6” elements"
                "to add identifying headings to all articles."
              ].join " "
            ]
        ).catch((e) -> throw e).done (-> done()), done

    describe "File input", ->

      describe "Single file", ->
        it "There should be proper errors", (done) ->
          file = "./tests/data/invalid.html"
          vnu.validateFiles(file).then(
            (result) ->
              result[file].splice 0,2
              expect(result[file]).eql [
                "lastLine": 8
                "lastColumn": 13
                "extract": "body>\n    <article>\n     "
                "firstColumn": 5
                "hiliteLength": 9
                "hiliteStart": 10
                "type": "info"
                "subType": "warning"
                "message": [
                  "Article lacks heading. Consider using “h2”-“h6” elements"
                  "to add identifying headings to all articles."
                ].join " "
              ]
          ).catch((e) -> throw e).done (-> done()), done

      describe "Multiple files", ->
        it "There should be proper errors", (done) ->
          files = [
            "./tests/data/invalid.html"
            "./tests/data/invalid2.html"
          ]
          vnu.validateFiles(files).then(
            (result) ->
              for file, data of result
                expect(files).include file
                data.splice 0, 2
                if file is "./tests/data/invalid.html"
                  expect(data).eql [
                    "extract": "body>\n    <article>\n     "
                    "firstColumn": 5
                    "hiliteLength": 9
                    "hiliteStart": 10
                    "lastLine": 8
                    "lastColumn": 13
                    "type": "info"
                    "subType": "warning"
                    "message": [
                      "Article lacks heading. Consider using"
                      "“h2”-“h6” elements"
                      "to add identifying headings to all articles."
                    ].join " "
                  ]
                else
                  expect(data).eql [
                    "extract": "id HTML :(</p>\n</bod"
                    "firstColumn": 53
                    "hiliteLength": 4
                    "hiliteStart": 10
                    "lastLine": 8
                    "lastColumn": 56
                    "type": "error"
                    "message": [
                      "No “p” element in scope but a “p” end tag seen."
                    ].join " "
                  ]
          ).catch((e) -> throw e).done (-> done()), done

        it "Repeating a file name should be all right", ->
          files = [
            "./tests/data/invalid.html"
            "./tests/data/invalid.html"
          ]
          vnu.validateFiles files
