vnu = require "../../lib/validatornu"
expect = require("chai").expect

describe "Invalid callback tests", ->
  describe "Raw text input", ->
    commonIt = (input, callback)->
      it "Shouldn't throw any errors", ->
        expect(
          -> vnu.validate input, callback, process.env.VNU_BIN
        ).not.throw Error
    describe "Callback is string", ->
      commonIt "<html>", "test"
    describe "Callback is number", ->
      commonIt("<html>", 1234)
    describe "Callback is object", ->
      commonIt "<html>", "a": "b"
    describe "Callback is list", ->
      commonIt "<html>", ["a"]

  describe "File input", ->
    commonIt = (input, callback) ->
      it "Shouldn't throw any errors", ->
        expect(
          -> vnu.validateFiles input, callback, process.env.VNU_BIN
        ).not.throw Error

    describe "Callback is string", ->
      commonIt "tests/data/valid.html", "test"
    describe "Callback is number", ->
      commonIt "tests/data/valid.html", 1234
    describe "Callback is object", ->
      commonIt "tests/data/valid.html", "a": "b"
    describe "Callback is list", ->
      commonIt "tests/data/valid.html", ["a"]
