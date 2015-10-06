expect = require("chai").expect
genArgs = require("../../src/helper").genArgs

describe "Argument generator tests (Standard)", ->
  args =
    "thisIsATest": 5
    "skipNonHtml": true

  describe "Without __private option", ->
    describe "Not contains any reserved options", ->
      it "The arguments should be generated as it is", ->
        expect(genArgs args).eql [
          "--this-is-a-test", "5", "--skip-non-html"
        ]

    describe "Contains format option", ->
      before ->
        args.format = "json"
      after ->
        delete args.format
      it "The argument should be generated without format option", ->
        expect(genArgs args).eql [
          "--this-is-a-test", "5", "--skip-non-html"
        ]
  describe "With __private option", ->
    describe "Not contains any reserved options", ->
      it "The arguments should be generated as it is", ->
        expect(genArgs args).eql [
          "--this-is-a-test", "5", "--skip-non-html"
        ]

    describe "Contains format option", ->
      before ->
        args.format = "json"
      after ->
        delete args.format
      it "The argument should be generated without format option", ->
        expect(genArgs args, false, true).eql [
          "--this-is-a-test", "5", "--skip-non-html", "--format", "json"
        ]

describe "Argument generator tests (non-standard options for Java)", ->
  args =
    "ss": "512k"
    "ms": "256k"
    "share:": "auto"
  it "The arguments should be generated with single hyphen and X prefixed", ->
    expect(genArgs args, true).eql ["-Xss512k", "-Xms256k", "-Xshare:auto"]
