spawn = require("child_process").spawn
path = require "path"
q = require("q")
http = require "http"
fs = require "fs"
freeport = require "freeport"

helper = require "./helper"

class Vnu
  constructor: (@xargs={}, @args={}, @vnuPath=helper.vnuJar, @verbose) ->
    @server = null

  "open": =>
    q.nfcall(freeport).then (port) =>
      @port = port
      argsToPass = helper.genArgs(@xargs, true).concat(
        "-cp", @vnuPath,
        "nu.validator.servlet.Main", port.toString(10),
        helper.genArgs(@args),
      )
      defer = q.defer()
      stderrData = []
      try
        server = @server = spawn helper.javaBin(), argsToPass
        @server.on "exit", (code, signal) ->
          if stderrData
            stderrData.forEach(process.stderr.write.bind(process.stderr))
          if code == null
            defer.reject(new Error("The server exited on signal " + signal))
          else if code != 0
            defer.reject(new Error("The server exited with code " + code))
        @server.on "error", (err) ->
          defer.reject(err)
        @server.stderr.on "data", (data) ->
          dataStr = data.toString()
          if dataStr.match /INFO:oejs\.Server:main: Started @/
            stderrData = null
            defer.resolve server.pid
          else if stderrData != null
            stderrData.push(data)
        @server.stderr.on "end", ->
          if @verbose
            console.log "The server is opened on port #{@port}"
      catch e
        defer.reject(e)
      finally
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
        "Content-Length": Buffer.byteLength input
    try
      req = http.request post_option, (res) ->
        if res.statusCode > 299 or res.statusCode < 200
          defer.reject(
            new Error("Server side error! code: #{res.statusCode}")
          )
          return
        res.setEncoding "utf8"
        res.on "data", (chunk) ->
          data.push chunk.toString()
        res.on "end", ->
          try
            data = JSON.parse(data.join("")).messages
            defer.resolve data
          catch e
            defer.reject e
      req.on "error", defer.reject
      req.write input
      req.end()
    catch e
      defer.reject e
    finally
      return defer.promise

  "validateFiles": (files) ->
    filesToPass = [].concat files
    numResults = 0
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
              result[file] = validationResult
              numResults++
              if numResults is filesToPass.length
                defer.resolve result
          ).catch(defer.reject)
    catch e
      defer.reject e
    finally
      return defer.promise

exports.Vnu = Vnu
