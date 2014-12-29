var luamin = require('luamin');

module.exports = function(grunt) {
  grunt.initConfig({
    'build-opk': {
      all: {
        src: 'app',
        dest: 'build/2048.opk'
      }
    },

    'build-love': {
      all: {
        src: 'app',
        dest: '../build/2048.love'
      }
    },

    luamin: {
      all: {
        files: {
          src: ['app/**/*.lua']
        }
      }
    },

    moonscript: {
      all: {
        files: {
          src: ['**/*.moon'],
          dest: '../app',
          cwd: 'src'
        },
      }
    },

    watch: {
      moon: {
        files: ['src/**/*.moon'],
        tasks: ['moonscript']
      }
    }
  });

  grunt.registerMultiTask('luamin', 'Minify lua files', function () {
    grunt.file.expand(this.data.files.src).forEach(function (file) {
      grunt.file.write(file, luamin.minify(grunt.file.read(file)));
    });
  });

  grunt.registerMultiTask('moonscript', 'Compile moonscript files', function () {
    var data = this.data;
    var files = grunt.file.expand({ cwd: data.files.cwd }, data.files.src);

    grunt.util.spawn({
      cmd: 'moonc',
      args: ['-t', data.files.dest].concat(files),
      opts: {
        cwd: data.files.cwd
      }
    }, this.async());
  });

  grunt.registerMultiTask('build-opk', 'Build OPK package (for GCW-Zero game console)', function () {
    grunt.file.write(this.data.dest, '');
    grunt.util.spawn({
      cmd: 'mksquashfs',
      args: [this.data.src, this.data.dest, '-all-root', '-noappend', '-no-exports', '-no-xattrs']
    }, this.async());
  });

  grunt.registerMultiTask('build-love', 'Build .love file', function () {
    grunt.file.write(this.data.dest, '');
    grunt.util.spawn({
      cmd: 'zip',
      args: ['-9', '-r', this.data.dest, '.'],
      opts: {
        cwd: this.data.src
      }
    }, this.async());
  });

  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.registerTask('default', ['watch']);
  grunt.registerTask('build', ['moonscript']);
  grunt.registerTask('minify', ['luamin']);
  grunt.registerTask('package', ['build', 'minify', 'build-opk']);
}
