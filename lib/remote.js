(function() {
  var Vnu, deepcopy, fs, http, path, q, spawn,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  spawn = require("child_process").spawn;

  path = require("path");

  q = require("q");

  http = require("http");

  fs = require("fs");

  deepcopy = require("deepcopy");

  Vnu = (function() {
    function Vnu(vnuPath, verbose) {
      this.vnuPath = vnuPath != null ? vnuPath : "/usr/share/java/validatornu/vnu.jar";
      this.verbose = verbose;
      this["validate"] = bind(this["validate"], this);
      this["close"] = bind(this["close"], this);
      this["open"] = bind(this["open"], this);
      this.port = Math.floor(Math.random() * 100000) % 65535;
      if (this.port < 1024) {
        this.port += 1024;
      }
      this.server = null;
    }

    Vnu.prototype["open"] = function() {
      var defer, server;
      defer = q.defer();
      try {
        server = this.server = spawn(path.join(process.env.JAVA_HOME || "/", "bin", "java"), ["-cp", this.vnuPath, "nu.validator.servlet.Main", this.port.toString(10)]);
        this.server.on("error", function(err) {
          return defer.reject(err);
        });
        this.server.stderr.on("data", function(data) {
          var dataStr;
          dataStr = data.toString();
          if (dataStr.match(/INFO:oejs\.Server:main: Started @/)) {
            return defer.resolve(server.pid);
          }
        });
        return this.server.stderr.on("end", function() {
          if (this.verbose) {
            return console.log("The server is opened on port " + this.port);
          }
        });
      } catch (_error) {
        return defer.reject(e);
      } finally {
        return defer.promise;
      }
    };

    Vnu.prototype["close"] = function() {
      var defer, e, signal;
      defer = q.defer();
      signal = "SIGHUP";
      this.server.on("error", function(err) {
        if (signal === "SIGHUP") {
          signal = "SIGINT";
        } else if (signal === "SIGINT") {
          signal = "SIGTERM";
        } else if (signal === "SIGTERM") {
          signal = "SIGKILL";
        } else {
          defer.reject(new Error(err));
          return;
        }
        return this.server.kill(signal);
      });
      this.server.on("close", function(code, signal) {
        return defer.resolve(code, signal);
      });
      try {
        return this.server.kill(signal);
      } catch (_error) {
        e = _error;
        return defer.reject(e);
      } finally {
        return defer.promise;
      }
    };

    Vnu.prototype["validate"] = function(input) {
      var data, defer, e, post_option, req;
      defer = q.defer();
      data = [];
      post_option = {
        "host": "127.0.0.1",
        "port": this.port,
        "path": "/?out=json",
        "method": "POST",
        "headers": {
          "Content-Type": "text/html; charset=utf-8",
          "Content-Length": input.length
        }
      };
      try {
        req = http.request(post_option, function(res) {
          if (res.statusCode > 299 || res.statusCode < 200) {
            defer.reject(new Error("Server side error! code: " + res.statusCode));
            return;
          }
          res.setEncoding("utf8");
          res.on("data", function(chunk) {
            return data.push(chunk.toString());
          });
          return res.on("end", function() {
            data = JSON.parse(data.join("")).messages;
            return defer.resolve(data);
          });
        });
        req.on("error", defer.reject);
        req.write(input);
        return req.end();
      } catch (_error) {
        e = _error;
        return defer.reject(e);
      } finally {
        return defer.promise;
      }
    };

    Vnu.prototype["validateFiles"] = function(files) {
      var defer, e, file, filesToPass, i, len, result, results;
      filesToPass = [].concat(files);
      result = {};
      defer = q.defer();
      try {
        results = [];
        for (i = 0, len = filesToPass.length; i < len; i++) {
          file = filesToPass[i];
          results.push((function(_this) {
            return function(file) {
              return q.nfcall(fs.readFile, file).then(function(input) {
                return _this.validate(input);
              }).then(function(validationResult) {
                result[file] = deepcopy(validationResult);
                if (Object.keys(result).length === filesToPass.length) {
                  return defer.resolve(result);
                }
              })["catch"](defer.reject);
            };
          })(this)(file));
        }
        return results;
      } catch (_error) {
        e = _error;
        return defer.reject(e);
      } finally {
        return defer.promise;
      }
    };

    return Vnu;

  })();

  exports.Vnu = Vnu;

}).call(this);
