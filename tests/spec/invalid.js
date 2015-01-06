/*global exports, require, process*/
(function (exports, require, process) {
    "use strict";
    exports.testInvalidData = function (test) {
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
                test.equal(result[0].type, "info", "type be should be \"info\".");
                test.equal(result[0].subType, "warning", "result.subType be should be \"warning\".");
                test.equal(result[0].message,
                           "Article lacks heading. Consider using “h2”-“h6” elements " +
                           "to add identifying headings to all articles.",
                           "result.message should be the corresponding message.");
                test.done();
            }, process.env.VNU_BIN);
        });
    };

    exports.testInvalidFile = function (test) {
        var validatornu = require("../../lib/validatornu");
        validatornu.validateFiles(
            "./tests/data/invalid.html",
            function (result) {
                test.equal(result.length, 1, "result should have something.");
                test.ok(
                    result[0].url.search(
                        /tests\/data\/invalid\.html$/
                    ) >= 0,
                    "url should be matched with tests/data/invalid.html"
                );
                test.equal(result[0].lastLine, 8, "lastLine should be 8.");
                test.equal(result[0].lastColumn, 13, "lastColumn should be 13.");
                test.equal(result[0].type, "info", "type be should be \"info\".");
                test.equal(result[0].subType, "warning", "subType be should be \"warning\".");
                test.equal(result[0].message,
                           "Article lacks heading. Consider using “h2”-“h6” elements " +
                           "to add identifying headings to all articles.",
                           "result.message should be the corresponding message.");
                test.done();
            },
            process.env.VNU_BIN
        );
    };

    exports.testInvalidFiles = function (test) {
        var validatornu = require("../../lib/validatornu");
        validatornu.validateFiles(
            [
                "./tests/data/invalid.html",
                "./tests/data/invalid2.html"
            ],
            function (result) {
                test.equal(result.length, 2, "result should have 2 errors.");
                result.forEach(function (msg) {
                    test.ok(
                        msg.url.search(/tests\/data\/(invalid|invalid2)\.html$/) >= 0,
                        "url should be matched with tests/data/invalid.html or " +
                            "tests/data/invalid2.html"
                    );
                    if (msg.url.search(/tests\/data\/invalid\.html$/) >= 0) {
                        test.equal(msg.lastLine, 8, "lastLine should be 8.");
                        test.equal(msg.lastColumn, 13, "lastColumn should be 13.");
                        test.equal(msg.type, "info", "type be should be \"info\".");
                        test.equal(msg.subType, "warning", "subType be should be \"warning\".");
                        test.equal(msg.message,
                                   "Article lacks heading. Consider using “h2”-“h6” elements " +
                                   "to add identifying headings to all articles.",
                                   "result.message should be the corresponding message.");
                    } else if (msg.url.search(/tests\/data\/invalid2\.html$/)  >= 0) {
                        test.equal(msg.lastLine, 8, "lastLine should be 8.");
                        test.equal(msg.lastColumn, 56, "lastColumn should be 56.");
                        test.equal(msg.type, "error", "type be should be \"error\".");
                        test.equal(msg.message,
                                   "No “p” element in scope but a “p” end tag seen.");

                    }
                });
                test.done();
            },
            process.env.VNU_BIN
        );
    };

    exports.testValidAndInvalidFiles = function (test) {
        var validatornu = require("../../lib/validatornu");
        validatornu.validateFiles(
            [
                "./tests/data/valid.html",
                "./tests/data/invalid2.html"
            ],
            function (result) {
                test.equal(result.length, 1, "result should have an error.");
                result.forEach(function (msg) {
                    test.ok(
                        msg.url.search(/tests\/data\/invalid2\.html$/) >= 0,
                        "url should be matched with tests/data/invalid2.html"
                    );
                    if (msg.url.search(/tests\/data\/invalid2\.html$/)  >= 0) {
                        test.equal(msg.lastLine, 8, "lastLine should be 8.");
                        test.equal(msg.lastColumn, 56, "lastColumn should be 56.");
                        test.equal(msg.type, "error", "type be should be \"error\".");
                        test.equal(msg.message,
                                   "No “p” element in scope but a “p” end tag seen.");

                    }
                });
                test.done();
            },
            process.env.VNU_BIN
        );
    };
}(exports, require, process));
