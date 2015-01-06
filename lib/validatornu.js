/*global exports, require, process*/
/*jslint unparam: true*/
(function (exports, require, process) {
    "use strict";
    exports.validate = function (input, callback, vnuPath) {
        var validatorPath = vnuPath || "/usr/share/java/validatornu/vnu.jar",
            spawn = require("child_process").spawn,
            path = require("path"),
            validator = spawn(
                path.join(process.env.JAVA_HOME || "/", "bin", "java"),
                ["-jar", validatorPath, "--format", "json", "-"]
            );
        validator.stderr.on("data", function (data) {
            if (typeof callback === "function") {
                callback(JSON.parse(data).messages);
            }
        });
        validator.stdin.write(input);
        validator.stdin.end();
    };
    exports.validateFiles = function (files, callback, vnuPath) {
        var validatorPath = vnuPath || "/usr/share/java/validatornu/vnu.jar",
            spawn = require("child_process").spawn,
            path = require("path"),
            args,
            validator,
            files_to_process = [];

        if (files instanceof Array) {
            files_to_process.push.apply(
                files_to_process,
                files
            );
        } else {
            files_to_process.push(files);
        }
        args = ["-jar", validatorPath, "--format", "json"].concat(
            files_to_process
        );
        validator = spawn(
            path.join(process.env.JAVA_HOME || "/", "bin", "java"),
            args
        );
        validator.stderr.on("data", function (data) {
            if (typeof callback === "function") {
                callback(JSON.parse(data).messages);
            }
        });
    };
}(exports, require, process));
