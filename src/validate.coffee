module.exports = (input, vnuPath)->
  validatorPath = vnuPath or "/usr/share/java/validatornu/vnu.jar"
  spawn = require("child_process").spawn
  path = require "path"
  defer = require("q").defer()
  try
    validator = spawn(
      path.join(process.env.JAVA_HOME or "/", "bin", "java"),
      ["-jar", validatorPath, "--format", "json", "-"]
    )
    validator.stderr.on "data", (data) ->
      defer.resolve JSON.parse(data).messages
    validator.stdin.write input
    validator.stdin.end()
  catch e
    defer.reject(e)
  finally
    return defer.promise
