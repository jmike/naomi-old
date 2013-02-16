fs = require("fs")
path = require("path")
exec = require("child_process").exec
Mocha = require("mocha")

meta = JSON.parse(fs.readFileSync("package.json", "utf-8"))

option("-u", "--unit [FILENAME]", "Specify the unit test to run")

task("test", "Runs naomi unit tests.", (options) ->
	mocha = new Mocha({
		reporter: "spec"
	})
	if options.unit?
		mocha.addFile(
			path.join("test", path.basename(options.unit) + "." + (path.extname(options.unit) || "coffee"))
		)
	else
		fs.readdirSync("test").forEach((file) ->
			mocha.addFile(
				path.join("test", file)
			)
		)
	mocha.run((failures) ->
		process.exit(failures)
	)
)

task("docs", "Generates documentation for #{meta.name} v.#{meta.version}.", (options) ->
	exec("codo --output-dir docs --name #{meta.name} --title '#{meta.name} #{meta.version}' --private --cautious src - LICENSE", (error, stdout, stderr) ->
		if error? then throw error
		console.log(stdout + stderr)
	)
)