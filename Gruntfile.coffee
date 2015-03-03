module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)
  grunt.initConfig
    connect: server: options:
      base: 'public'
      port: 1337
    watch:
      json:
        files: [ 'data.json' ]
        tasks: [ 'build' ]
      scss:
        files: [ 'src/styles/*.scss' ]
        tasks: [ 'sass' ]
      coffee:
        files: [ 'src/scripts/*.coffee' ]
        tasks: [ 'coffee' ]
      jade:
        files: [ 'src/**/*.jade' ]
        tasks: [ 'jade' ]
      css:
        files: [ 'public/*.css' ]
        options: livereload: true
      js:
        files: [ 'public/*.js' ]
        options: livereload: true
      html:
        files: [ 'public/*.html' ]
        options: livereload: true
    coffee:
      compile:
        files: 'public/app.js': 'src/scripts/app.coffee'
    sass:
      options:
        outputStyle: 'compressed'
        includePaths: require('node-neat').with('node-bourbon')
      dist:
        files:
          'public/styles.min.css': 'src/styles/styles.scss'
    jade:
      compile:
        options:
          data: (dest, src) ->
            require './data.json'
        files: [
          cwd: 'src/views'
          src: '**/*.jade'
          dest: 'public/'
          expand: true
          ext: '.html'
        ]
    'ftp-deploy':
      build:
        auth:
          host: 'tygla.com'
          port: 21
          authKey: 'key1'
        src: 'public'
        dest: 'tygla.com'

  grunt.registerTask 'default', [
    'sass'
    'coffee'
    'jade'
    'connect'
    'watch'
  ]

  grunt.registerTask 'build', [
    'sass'
    'coffee'
    'jade'
  ]

  grunt.registerTask 'deploy', [ 'ftp-deploy' ]

  grunt.registerTask 'ship', [
    'build'
    'ftp-deploy'
  ]
