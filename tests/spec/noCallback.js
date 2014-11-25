/*global exports, require, process*/
(function (exports, require, process) {
    "use strict";
    exports.testDefine = function (test) {
        var validatornu = require("../../lib/validatornu");
        test.doesNotThrow(
            function () {
                validatornu.validate("<html>", undefined, process.env.VNU_BIN);
            }
        );
        test.done();
    };
}(exports, require, process));
