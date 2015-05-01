(function() {
  module.exports = function(files, callback, vnuPath) {
    var args, path, spawn, validator, validatorPath;
    validatorPath = vnuPath || "/usr/share/java/validatornu/vnu.jar";
    spawn = require("child_process").spawn;
    path = require("path");
    args = ["-jar", validatorPath, "--format", "json"].concat(files);
    validator = spawn(path.join(process.env.JAVA_HOME || "/", "bin", "java"), args);
    return validator.stderr.on("data", function(data) {
      if (typeof callback === "function") {
        return callback(JSON.parse(data).messages);
      }
    });
  };

}).call(this);
