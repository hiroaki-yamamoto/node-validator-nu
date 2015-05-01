module.exports = (files, vnuPath="/usr/share/java/validatornu/vnu.jar") ->
  spawn = require("child_process").spawn
  path = require "path"
  args = ["-jar", vnuPath, "--format", "json"].concat files
  defer = require("q").defer()

  try
    validator = spawn(
      path.join(process.env.JAVA_HOME || "/", "bin", "java"),
      args
    )
    validator.stderr.on "data", (data) ->
      defer.resolve JSON.parse(data).messages
  catch e
    validator.reject e
  finally
    return defer.promise
