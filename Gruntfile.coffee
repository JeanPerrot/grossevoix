env = (environment='development') ->
  process.env.NODE_ENV = environment
  require 'config'

module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-nodemon'
  grunt.loadNpmTasks 'grunt-env'


  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'
    env:
      dev_windows:
        NODE_ENV: 'dev_windows'
    clean:
      bin: [ 'bin' ]
      dist: [ 'dist' ]
    copy:
      dist:
        files: [
          { expand: true, src: 'public/**', dest: 'dist' }
          { expand: true, src: 'views/mail/**', dest: 'dist' }
          { expand: true, src: 'package.json', dest: 'dist' }
        ]
    nodemon:
      dev:
        script: 'bin/lib/index.js'
    watch:
      coffee:
        files: ['src/**/*.coffee'],
        tasks: 'coffee'
    coffee:
      lib:
        expand: true
        cwd: 'src'
        src: '**/*.coffee'
        dest: 'bin/lib'
        ext: '.js'
        options:
          sourceMap: true
      config:
        expand: true
        cwd: 'config'
        src: '**/*.coffee'
        dest: 'bin/config'
        ext: '.js'
      test:
        expand: true
        cwd: 'test'
        src: '**/*.coffee'
        dest: 'bin/test'
        ext: '.js'
      db:
        expand: true
        cwd: 'db'
        src: '**/*.coffee'
        dest: 'bin/db'
        ext: '.js'
    mochaTest:
      test:
        options:
          reporter: 'spec',
          require: [
            'coffee-script/register'
            'test/setup.coffee'
          ]
        src: [ 'test/**/*.coffee' ]

      coverage:
        options:
          reporter: 'html-cov'
          quiet: true
          captureFile: 'coverage.html'
          require: [
            'coffee-script/register'
            'test/coverage.coffee'
            'test/setup.coffee'
          ]
        src: [ 'test/**/*.coffee' ]

  grunt.registerTask 'test', [ 'mochaTest:test' ]



  # grunt.registerTask 'procfile', 'Generate procfile', ->
  #   grunt.file.write 'dist/Procfile', 'web: node lib'

  # grunt.registerTask 'dist', ['copy', 'coffee', 'uglify', 'procfile']

  # grunt.registerTask 'deploy', 'Deploy to heroku', (remote) ->
  #   aliases =
  #     prod: 'iddentity'
  #   unless aliases[remote]?
  #     grunt.log.error "Invalid remote provided.  Must be one of [#{(name for name, it of aliases).join(', ')}]."
  #     return false
  #   grunt.task.requires 'dist'
  #   done = @async()
  #   git = (args..., callback) ->
  #     proc = grunt.util.spawn cmd: 'git', args: args, opts: {cwd: 'dist'}, (err) ->
  #       if err?
  #         done false
  #       else
  #         callback()
  #   grunt.file.delete 'dist/.git'
  #   git 'init', ->
  #     git 'add', '.', ->
  #       git 'commit', '--allow-empty', '-m', "Deploying to #{aliases[remote]}.", ->
  #         git 'remote', 'add', '-f', remote, "git@heroku.com:#{aliases[remote]}.git", ->
  #           git 'push', '-f', remote, 'master', done
  #


  grunt.registerTask 'redis:drop','Wipes redis', (environment) ->
    config = env environment
    grunt.util.spawn {cmd: 'redis-cli', args: ['flushdb']}, ->
