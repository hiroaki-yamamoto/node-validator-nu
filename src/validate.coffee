helper = require "./helper"
module.exports = (input, xargs={}, args={}, vnuPath=helper.vnuJar) ->
  spawn = require("child_process").spawn
  path = require "path"
  defer = require("q").defer()
  argsToPass = helper.genArgs(xargs, true).concat(
    "-jar", vnuPath,
    helper.genArgs("format": "json", false, true),
    helper.genArgs(args),
    "-"
  )
  result = []
  try
    validator = spawn helper.javaBin(), argsToPass
    validator.stderr.on "data", (data) ->
      result.push data
    validator.stderr.on "end", ->
      defer.resolve JSON.parse(result.join("")).messages
    validator.stdin.write input
    validator.stdin.end()
  catch e
    defer.reject(e)
  finally
    return defer.promise
