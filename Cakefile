fs = require("fs")
path = require("path")
Mocha = require("mocha")

task("test", "Runs naomi unit tests.", (options) ->
	mocha = new Mocha({
		reporter: "spec"
	})
	fs.readdirSync("test").forEach((file) ->
		mocha.addFile(
			path.join("test", file)
		)
	)
	mocha.run((failures) ->
		process.exit(failures)
	)
)