/*global exports, require, process*/
(function (exports, require, process) {
    "use strict";
    exports.testValidData = function (test) {
        var fs = require("fs"),
            validatornu = require("../../lib/validatornu");
        fs.readFile("./tests/data/valid.html", function (err, data) {
            if (err) {
                throw err;
            }
            validatornu.validate(data, function (result) {
                test.equal(result.length, 0, "result shouldn't have anything.");
                test.done();
            }, process.env.VNU_BIN);
        });
    };
    exports.testValidFile = function (test) {
        var validatornu = require("../../lib/validatornu");
        validatornu.validateFiles(
            "./tests/data/valid.html",
            function (result) {
                test.equal(
                    result.length,
                    0,
                    "result shouldn't have anything"
                );
                test.done();
            },
            process.env.VNU_BIN
        );
    };
    exports.testValidFiles = function (test) {
        var validatornu = require("../../lib/validatornu");
        validatornu.validateFiles(
            [
                "./tests/data/valid.html",
                "./tests/data/valid2.html"
            ],
            function (result) {
                test.equal(
                    result.length,
                    0,
                    "result shouldn't have anything"
                );
                test.done();
            },
            process.env.VNU_BIN
        );
    };
}(exports, require, process));
