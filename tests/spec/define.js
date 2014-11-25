/*global exports, require*/
(function (exports, require) {
    "use strict";
    exports.testDefine = function (test) {
        var validatornu = require("../../lib/validatornu");
        test.ok(validatornu, "validatornu module not found.");
        test.done();
    };
}(exports, require));
