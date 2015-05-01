module.exports = (input, callback, vnuPath)->
  validatorPath = vnuPath or "/usr/share/java/validatornu/vnu.jar"
  spawn = require("child_process").spawn
  path = require "path"
  validator = spawn(
    path.join(process.env.JAVA_HOME or "/", "bin", "java"),
    ["-jar", validatorPath, "--format", "json", "-"]
  )
  validator.stderr.on "data", (data) ->
    if typeof callback is "function"
      callback JSON.parse(data).messages
  validator.stdin.write input
  validator.stdin.end()
