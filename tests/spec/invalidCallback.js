/*global exports, require*/
(function (exports, require) {
    "use strict";
    exports.testDefine = function (test) {
        var validatornu = require("../../lib/validatornu");
        test.doesNotThrow(
            function () {
                validatornu.validate("<html>", "blaaaaa");
            }
        );
        test.doesNotThrow(
            function () {
                validatornu.validate("<html>", 12345);
            }
        );
        test.doesNotThrow(
            function () {
                validatornu.validate("<html>", {
                    "a": "b"
                });
            }
        );
        test.doesNotThrow(
            function () {
                validatornu.validate("<html>", ["a"]);
            }
        );
        test.done();
    };
}(exports, require));
