module.exports = (grunt) ->

	Mocha = require("mocha")

	grunt.registerMultiTask("mocha", "Runs server-side mocha tests.", ->
		done = this.async()
		options = this.options({
			reporter: "spec"
		})

		mocha = new Mocha(options)
		for file in this.filesSrc
			mocha.addFile(file)

		try
			mocha.run((failures) ->
				done(failures is 0)
			)
		catch error
			done(error)
	)
	
	grunt.loadNpmTasks("grunt-exec")

	grunt.initConfig({
		pkg: grunt.file.readJSON("package.json")
		
		mocha: {
			datatypes: {
				options: {
					reporter: "spec"
				}
				files: [
					{
						src: "test/datatypes/*.coffee"
					}
				]
			}
			mysql: {
				options: {
					reporter: "spec"
				}
				files: [
					{
						src: "test/mysql/*.coffee"
					}
				]
			}
		}
		
		exec: {
			codo: {
				command: ->
					pkg = grunt.file.readJSON("package.json")
					return "codo --output-dir docs --name #{pkg.name} --title '#{pkg.name} #{pkg.version}' --private --cautious src - LICENSE"
			}
		}
	})

	grunt.registerTask("test", [
		"mocha:datatypes"
		"mocha:mysql"
	])
	grunt.registerTask("docs", ["exec:codo"])