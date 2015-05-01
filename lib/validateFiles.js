(function() {
  module.exports = function(files, vnuPath) {
    var args, defer, e, path, spawn, validator, validatorPath;
    validatorPath = vnuPath || "/usr/share/java/validatornu/vnu.jar";
    spawn = require("child_process").spawn;
    path = require("path");
    args = ["-jar", validatorPath, "--format", "json"].concat(files);
    defer = require("q").defer();
    try {
      validator = spawn(path.join(process.env.JAVA_HOME || "/", "bin", "java"), args);
      return validator.stderr.on("data", function(data) {
        return defer.resolve(JSON.parse(data).messages);
      });
    } catch (_error) {
      e = _error;
      return validator.reject(e);
    } finally {
      return defer.promise;
    }
  };

}).call(this);
