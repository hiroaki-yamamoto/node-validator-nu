path = require "path"
dargs = require "dargs"

module.exports =

  vnuJar: require "vnu-jar"

  javaBin: ->
    if process.env.JAVA_HOME
      path.join(process.env.JAVA_HOME, "bin", "java")
    else
      "java"

  genArgs: (args, xprefixed, __private) ->
    result = []
    exclude = if __private then undefined else ["format"]
    if args is undefined
      args = {}
    if xprefixed
      Object.keys(args).forEach (key) ->
        result.push "-X#{key}#{args[key]}"
      return result
    preResult = dargs(args, (
      "excludes": exclude
    )).map (arg) -> arg.split "="
    preResult.forEach (arg) -> result = result.concat arg
    return result
