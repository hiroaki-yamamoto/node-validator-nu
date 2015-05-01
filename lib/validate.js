(function() {
  module.exports = function(input, callback, vnuPath) {
    var path, spawn, validator, validatorPath;
    validatorPath = vnuPath || "/usr/share/java/validatornu/vnu.jar";
    spawn = require("child_process").spawn;
    path = require("path");
    validator = spawn(path.join(process.env.JAVA_HOME || "/", "bin", "java"), ["-jar", validatorPath, "--format", "json", "-"]);
    validator.stderr.on("data", function(data) {
      if (typeof callback === "function") {
        return callback(JSON.parse(data).messages);
      }
    });
    validator.stdin.write(input);
    return validator.stdin.end();
  };

}).call(this);
