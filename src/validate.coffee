module.exports = (input, vnuPath="/usr/share/java/validatornu/vnu.jar")->
  spawn = require("child_process").spawn
  path = require "path"
  defer = require("q").defer()
  result = []
  try
    validator = spawn(
      path.join(process.env.JAVA_HOME or "/", "bin", "java"),
      ["-jar", vnuPath, "--format", "json", "-"]
    )
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
