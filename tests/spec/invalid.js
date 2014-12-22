/*global exports, require, process*/
(function (exports, require, process) {
    "use strict";
    exports.testInValidData = function (test) {
        var fs = require("fs"),
            validatornu = require("../../lib/validatornu");
        fs.readFile("./tests/data/invalid.html", function (err, data) {
            if (err) {
                throw err;
            }
            validatornu.validate(data, function (result) {
                test.equal(result.length, 1, "result should have something.");
                test.equal(result[0].lastLine, 8, "result.lastLine should be 8.");
                test.equal(result[0].lastColumn, 13, "result.lastColumn should be 13.");
                test.equal(result[0].subType, "warning", "result.subType be should be \"warning\".");
                test.equal(result[0].message,
                           "Article lacks heading. Consider using “h2”-“h6” elements " +
                           "to add identifying headings to all articles.",
                           "result.message should be the corresponding message.");
                test.done();
            }, process.env.VNU_BIN);
        });
    };
}(exports, require, process));
