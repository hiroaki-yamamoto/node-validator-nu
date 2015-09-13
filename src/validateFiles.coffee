helper = require "./helper"

module.exports = (files, vnuPath=helper.vnuJar) ->
  spawn = require("child_process").spawn
  path = require "path"
  args = ["-jar", vnuPath, "--format", "json"].concat files
  defer = require("q").defer()

  try
    validator = spawn(
      helper.javaBin(),
      args
    )
    validator.stderr.on "data", (data) ->
      try
        defer.resolve JSON.parse(data).messages
      catch e
        defer.reject e
  catch e
    defer.reject e
  finally
    return defer.promise
