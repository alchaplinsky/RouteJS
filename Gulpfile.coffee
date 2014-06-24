require 'coffee-script/register'

gulp    = require 'gulp'
coffee  = require 'gulp-coffee'
gutil   = require 'gulp-util'
jasmine = require 'gulp-jasmine'
watch   = require 'gulp-watch'

gulp.task 'build', ->
  gulp.src('./src/router.coffee')
    .pipe(coffee(bare: true).on('error', gutil.log))
    .pipe(gulp.dest('./dist/'))

gulp.task 'jasmine', ->
  gulp.src('./spec/*.coffee').pipe(jasmine())

gulp.task 'watch', ->
  gulp.src('./src/router.coffee').pipe(watch (files) ->
    files.pipe(coffee(bare: true).on('error', gutil.log))
    .pipe(gulp.dest('./dist/'))
  )
