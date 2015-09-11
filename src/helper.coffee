path = require "path"

module.exports =

  vnuJar: path.normalize(path.join(__dirname, "..", "vnu", "vnu.jar"))

  javaBin: ->
    if process.env.JAVA_HOME
      path.join(process.env.JAVA_HOME, "bin", "java")
    else
      "java"
