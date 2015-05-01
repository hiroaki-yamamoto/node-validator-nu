gulp = require "gulp"
mocha = require "gulp-mocha"
coffeelint = require "gulp-coffeelint"
coffee = require "gulp-coffee"
sourcemap = require "gulp-sourcemaps"

coffees = [
  "Gulpfile.coffee"
  "src/**/*.coffee"
  "tests/spec/*.coffee"
]

gulp.task "stylecheck", ->
  gulp.src(
    coffees
  ).pipe(
    coffeelint "./coffeelintOption.json"
  ).pipe(
    coffeelint.reporter()
  ).pipe(
    coffeelint.reporter('fail')
  )

gulp.task "test", ["stylecheck"], ->
  gulp.src(
    "tests/spec/*.coffee"
  ).pipe(mocha(
    "timeout": 300000
  ))

gulp.task "compile", ["stylecheck"], ->
  gulp.src(
    "src/**/*.coffee"
  ).pipe(coffee()).pipe(gulp.dest("./lib"))

gulp.task "default", ->
  gulp.watch(coffees, [
    "stylecheck"
    "compile"
    "test"
  ])
