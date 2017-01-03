# Local HTML 5 Validator NU API for nodejs

[![Build Status](https://travis-ci.org/hiroaki-yamamoto/node-validator-nu.svg?branch=master)](https://travis-ci.org/hiroaki-yamamoto/node-validator-nu)
[![devDependency Status](https://david-dm.org/hiroaki-yamamoto/node-validator-nu/dev-status.svg)](https://david-dm.org/hysoftware/node-validator-nu#info=devDependencies)

[![NPM](https://nodei.co/npm/validator-nu.png?downloads=true&downloadRank=true)](https://nodei.co/npm/validator-nu/)

## What this?

[Validator NU](http://validator.github.io/validator/) is known as a backend of
[W3C HTML Validator](http://validator.w3.org/), but it provides grunt task
file only, it doesn't provide API for node module.

This lib provides API to validate HTML for nodeJS.

## How to use ?
Theare are 2 ways to validate HTML since version 2.0.0.

### Legacy Style
First one is a legacy style. It takes 3-7 secs to launch, then validate files,
and finally, vnu.jar is closed. This takes time to launch for each call,
but you don't need to create an instance of "class" described below.

#### How to call function
Since version 2.0 callback function is replaced with
[Q](https://github.com/kriskowal/q). Hence, you will need to replace callback
function. For example, like this;

```node
var vnu = require("validator-nu");
// Put HTML data, not the name of the file.
vnu.validate("html here").then(function (result) {
    // callback
    // This API returns messages array.
}).catch(function (e) {
    // Error callback
});

// If you got an error validatornu was not found,
// set vnu path to 4th parameter.
vnu.validate(
    "html here",
    undefined,
    undefined,
    "/path/to/vnu.jar"
).then(function (result) {
    // callback
    // This API returns messages array.
}).catch(function (e) {
  // Error callback
});

// To validate file(s), use validateFiles function
vnu.validateFiles(
  [
    "./test.html",
    "./test2.html"
  ],
  "/path/to/vnu.jar" // Of course this argument is optional. You need to include the file name.
).then(function (result) {
    // callback
    // This API returns messages array.
}).catch(function (e) {
  // Error callback
});

// If you have only a file to validate, this style is also acceptable:
vnu.validateFiles(
  "./test.html",
  undefined,
  undefined,
  "/usr/bin/vnu.jar" // Of course this argument is optional. You need to include the file name.
).then(function (result) {
    // callback
    // This API returns messages array.
}).catch(function (e) {
  // Error callback
});
```

### Modern Style
Calling ```validate``` or ```validateFiles```, vnu.jar is launched for
each calls. Therefore, those functions are very slow as described above.
To avoid this problem, Launching vnu.jar as a long-term process
like HTTP service and using Web Interface API are needed.
(And these procedures are a little-bit weird...)

Since version 2.0.0, There is a class named ```Vnu``` that launches vnu.jar
as a HTTP server, and validate HTMLs.

### How to call the functions
Note that, you need to ensure the server is ready. Fortunately, ```open```
method returns promise object and call ```resolve``` when the server is ready.
For example, like this:

```node
vnu = new require("validator-nu").Vnu(
  undefined,
  undefined,
  "/path/to/vnu.jar" // optional, needs to include the file name
);
// open = launch server!
vnu.open().then(function(pid) {
  console.log("validator server@pid:" + pid);
  // Validate raw data
  return vnu.validate("html input");
}).then(function (result) {
  // For result, check: https://github.com/validator/validator/wiki/Output:-JSON
  // This API returns messages array.
  console.log(result);
  // To validate file(s), use validateFiles method:
  return vnu.validateFiles(["test.html", "test2.html"]);
}).then(function (result) {
  /*
   * The result is an object structured below:
   * {
   * "file path you input validateFiles. e.g. test.html in this example": [the corresponding messages array]
   * "test2.html": [the corresponding messages array]
   * }
   */
  console.log(result);
  // If you have only a file to validate, you can also write like this:
  return vnu.validateFiles("test.html");
}).then(function (result) {
  // The result is the same as above. i.e
  /*
    {
      "test.html": [the corresponding message array]
    }
   */
  console.log(result);
  // Don't forget to call close method, or runs validation server forever.
  return vnu.close()
}).then(function() {
  // Do something after the server is closed
}).catch(function (e) {
  // Error callback
  // EEEEEEESSSSSSCCCCAAAAAPPPEEEE!!!
  process.exit(1);
});
```

## Non-standard parameter for Java
As of 2.1.13, you can specify Non-standard parameters for Java (e.g. X prefixed option)
as 2nd parameter for legacy version, and as 1st parameter for "class" version.

For example, like this:

```node
vnu.validate("html here", {"ss": "512k"}).then(function (result) {
    // callback
    // This API returns messages array.
}).catch(function (e) {
    // Error callback
});

vnu.validateFiles("./test.html", {"ss": "512k"}).then(function (result) {
    // callback
    // This API returns messages array.
}).catch(function (e) {
  // Error callback
});

vnu = new require("validator-nu").Vnu(
  {"ss": "512k"},
  undefined,
  "/path/to/vnu.jar" // optional, needs to include the file name
);
```

## Application-specific parameter
As of 2.1.13, you can ALSO specify application-specific commandline arguments like this example:
```node
vnu.validate("html here", undefined, {"test": "test"}).then(function (result) {
    // callback
    // This API returns messages array.
}).catch(function (e) {
    // Error callback
});

vnu.validateFiles("./test.html", undefined, {"test": "test"}).then(function (result) {
    // callback
    // This API returns messages array.
}).catch(function (e) {
  // Error callback
});

vnu = new require("validator-nu").Vnu(
  undefined,
  {"test": "test"},
  "/path/to/vnu.jar" // optional, needs to include the file name
);
```

## Exceptions
Because this API uses [child_process.spawn](http://nodejs.org/api/child_process.html#child_process_child_process_spawn_command_args_options) and
[path.join](http://nodejs.org/api/path.html#path_path_join_path1_path2), sometimes the API throws
standard exceptions. In this case, you will need to check VNU Path and the target source file path...

## Contribution

When you send Pull Request, don't forget to add your name to "contributors" in
`package.json`.
