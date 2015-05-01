(function() {
  module.exports = function(input, vnuPath) {
    var defer, e, path, spawn, validator, validatorPath;
    validatorPath = vnuPath || "/usr/share/java/validatornu/vnu.jar";
    spawn = require("child_process").spawn;
    path = require("path");
    defer = require("q").defer();
    try {
      validator = spawn(path.join(process.env.JAVA_HOME || "/", "bin", "java"), ["-jar", validatorPath, "--format", "json", "-"]);
      validator.stderr.on("data", function(data) {
        return defer.resolve(JSON.parse(data).messages);
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
