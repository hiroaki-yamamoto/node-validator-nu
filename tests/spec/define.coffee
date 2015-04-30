expect = require("chai").expect
describe "Module definition check", ->
  it "The module should be defined", ->
    vnu = require "../../lib/validatornu"
    expect(vnu).ok
