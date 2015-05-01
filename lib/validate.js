(function() {
  module.exports = function(input, vnuPath) {
    var defer, e, path, result, spawn, validator;
    if (vnuPath == null) {
      vnuPath = "/usr/share/java/validatornu/vnu.jar";
    }
    spawn = require("child_process").spawn;
    path = require("path");
    defer = require("q").defer();
    result = [];
    try {
      validator = spawn(path.join(process.env.JAVA_HOME || "/", "bin", "java"), ["-jar", vnuPath, "--format", "json", "-"]);
      validator.stderr.on("data", function(data) {
        return result.push(data);
      });
      validator.stderr.on("end", function() {
        return defer.resolve(JSON.parse(result.join("")).messages);
      });
      validator.stdin.write(input);
      return validator.stdin.end();
    } catch (_error) {
      e = _error;
      return defer.reject(e);
    } finally {
      return defer.promise;
    }
  };

}).call(this);
