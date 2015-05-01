expect = require("chai").expect
describe "Module definition check", ->
  it "The module should be defined", ->
    vnu = require "../../src/validatornu"
    expect(vnu).ok
