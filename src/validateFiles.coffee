helper = require "./helper"
module.exports = (files, xargs={}, args={}, vnuPath=helper.vnuJar) ->
  spawn = require("child_process").spawn
  path = require "path"
  argsToPass = helper.genArgs(xargs, true).concat(
    "-jar", vnuPath,
    helper.genArgs("format": "json", false, true),
    helper.genArgs(args),
    files
  )
  defer = require("q").defer()

  try
    validator = spawn helper.javaBin(), argsToPass
    validator.stderr.on "data", (data) ->
      try
        defer.resolve JSON.parse(data).messages
      catch e
        defer.reject e
  catch e
    defer.reject e
  finally
    return defer.promise
