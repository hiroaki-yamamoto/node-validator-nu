spawn = require("child_process").spawn
path = require "path"
q = require("q")
http = require "http"
fs = require "fs"
deepcopy = require "deepcopy"

class Vnu
  constructor: (@vnuPath="/usr/share/java/validatornu/vnu.jar", @verbose) ->
    @port = Math.floor(Math.random()*100000)%65535
    if @port < 1024
      @port += 1024
    @server = null

  "open": =>
    defer = q.defer()
    server = @server = spawn(
      path.join(process.env.JAVA_HOME or "/", "bin", "java"),
      ["-cp", @vnuPath, "nu.validator.servlet.Main", @port.toString(10)]
    )
    @server.on "error", (err) ->
      defer.reject(err)
    @server.stderr.on "data", (data) ->
      dataStr = data.toString()
      if dataStr.match /INFO:oejs\.Server:main: Started @/
        defer.resolve server.pid
    @server.stderr.on "end", ->
      if @verbose
        console.log "The server is opened on port #{@port}"
    return defer.promise

  "close": =>
    defer = q.defer()
    signal = "SIGHUP"
    @server.on "error", (err) ->
      if signal is "SIGHUP"
        signal = "SIGINT"
      else if signal is "SIGINT"
        signal = "SIGTERM"
      else if signal is "SIGTERM"
        signal = "SIGKILL"
      else
        defer.reject(new Error(err))
        return
      @server.kill signal
    @server.on "close", (code, signal) ->
      defer.resolve code, signal
    try
      @server.kill signal
    catch e
      defer.reject e
    finally
      return defer.promise

  "validate": (input) =>
    defer = q.defer()
    data = []
    post_option =
      "host": "127.0.0.1"
      "port": @port
      "path": "/?out=json"
      "method": "POST"
      "headers":
        "Content-Type": "text/html; charset=utf-8"
        "Content-Length": input.length
    try
      req = http.request post_option, (res) ->
        if res.statusCode > 299 or res.statusCode < 200
          defer.reject(
            new Error("Server side error! code: #{res.statusCode}")
          )
          return
        res.setEncoding "utf8"
        res.on "data", (chunk) -> data.push chunk.toString()
        res.on "end", ->
          data = JSON.parse(data.join("")).messages
          defer.resolve data
      req.on "error", defer.reject
      req.write input
      req.end()
    catch e
      defer.reject e
    finally
      return defer.promise

  "validateFiles": (files) ->
    filesToPass = [].concat files
    result = {}
    defer = q.defer()
    try
      for file in filesToPass
        do (file) =>
          q.nfcall(
            fs.readFile, file
          ).then(
            (input) => @validate input
          ).then(
            (validationResult) ->
              result[file] = deepcopy validationResult
              if Object.keys(result).length is filesToPass.length
                defer.resolve result
          ).catch(defer.reject)
    catch e
      defer.reject e
    finally
      return defer.promise

exports.Vnu = Vnu
