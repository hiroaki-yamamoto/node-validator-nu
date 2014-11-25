/*global module, require*/
(function (module, require) {
    "use strict";
    module.exports = function (grunt) {
        var jslintTarget = [
            "lib/**/*.js",
            "Gruntfile.js",
            "package.json",
            "tests/spec/**/*.js"
        ], nodeUnitTarget = [
            "tests/spec/**/*.js"
        ];

        grunt.initConfig({
            "jslint": {
                "chk": {
                    "src": jslintTarget
                }
            },
            "nodeunit": {
                "all": nodeUnitTarget
            },
            "watch": {
                "dev": {
                    "files": [jslintTarget, "tests/data/**/*.html"],
                    "tasks": ["jslint", "nodeunit"]
                }
            }
        });
        grunt.registerTask("dev", "watch:dev");
        require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);
    };
}(module, require));
