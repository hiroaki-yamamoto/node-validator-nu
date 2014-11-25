/*global exports, require*/
(function (exports, require) {
    "use strict";
    exports.testDefine = function (test) {
        var validatornu = require("../../lib/validatornu");
        test.doesNotThrow(
            function () {
                validatornu.validate("<html>");
            }
        );
        test.done();
    };
}(exports, require));
