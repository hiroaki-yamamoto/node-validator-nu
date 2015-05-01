module.exports = (files, callback, vnuPath) ->
  validatorPath = vnuPath or "/usr/share/java/validatornu/vnu.jar"
  spawn = require("child_process").spawn
  path = require "path"
  args = ["-jar", validatorPath, "--format", "json"].concat files
  validator = spawn(
    path.join(process.env.JAVA_HOME || "/", "bin", "java"),
    args
  )
  validator.stderr.on "data", (data) ->
    if typeof callback is "function"
      callback JSON.parse(data).messages
