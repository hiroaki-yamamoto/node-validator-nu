/*global exports, require, process*/
(function (exports, require, process) {
    "use strict";
    exports.testDefine = function (test) {
        var validatornu = require("../../lib/validatornu");
        test.doesNotThrow(
            function () {
                validatornu.validate("<html>", "blaaaaa", process.env.VNU_BIN);
            }
        );
        test.doesNotThrow(
            function () {
                validatornu.validate("<html>", 12345, process.env.VNU_BIN);
            }
        );
        test.doesNotThrow(
            function () {
                validatornu.validate("<html>", {
                    "a": "b"
                }, process.env.VNU_BIN);
            }
        );
        test.doesNotThrow(
            function () {
                validatornu.validate("<html>", ["a"], process.env.VNU_BIN);
            }
        );
        test.done();
    };
}(exports, require, process));
