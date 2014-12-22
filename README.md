# Local VNu HTML 5 Validator API for nodejs

[![Build Status](https://travis-ci.org/hysoftware/node-validator-nu.svg?branch=master)](https://travis-ci.org/hysoftware/node-validator-nu)
[![devDependency Status](https://david-dm.org/hysoftware/node-validator-nu/dev-status.svg)](https://david-dm.org/hysoftware/node-validator-nu#info=devDependencies)
[![Code Climate](https://codeclimate.com/github/hysoftware/node-validator-nu/badges/gpa.svg)](https://codeclimate.com/github/hysoftware/node-validator-nu)

[![NPM](https://nodei.co/npm/validator-nu.png?downloads=true&downloadRank=true)](https://nodei.co/npm/validator-nu/)

## What this?

[Validator NU](http://validator.github.io/validator/) is known as a backend of [W3C HTML Validator](http://validator.w3.org/), but it provides grunt task file only, it doesn't provide API for node module.

In addition to this, I want to use this validator on Brackets, but unfortunately, it doesn't.
So, I created the API for nodejs and I hope this module is useful for creating HTML5 validator on various
IDEs for web developers.

## How to use ?
Just simple:

~~~~
/*global exports, require*/
(function (exports, require) {
    var vnu = require("validator-nu");
    // Put HTML data, not the name of the file.
    vnu.validate("html here", function () {
        // callback
    });
    // If you got validatornu was not found, set vnu path to 3rd parameter.
    vnu.validate("html here", function () {
        // callback
    }, "/usr/bin/vnu.jar");
}(exports, require));
~~~~
