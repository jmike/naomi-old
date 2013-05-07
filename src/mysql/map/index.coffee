esprima = require("esprima")
Expression = require("./expression")

class Map

	###
	Constructs a new mysql map to use in a select clause.
    @param {Function} callback a function that produces a new entity.
	@param {Object} thisObject object to use as this when executing callback.
	@throw {Error} if callback contains an invalid or unsupported expression.
    ###
	constructor: (callback, thisObject) ->
		try
			ast = esprima.parse("map = #{callback.toString()}")
		catch error
			throw new Error("Invalid javascript expression: #{error.message}")

		# callee is on the right
		callee = ast.body[0].expression.right

		# make sure callee parameters are valid
		if callee.params.length is 1
			entity = callee.params[0].name
		else
			throw Error("Invalid function parameters: expected exactly 1 parameter, got #{callee.params.length}")

		# make sure callee body is a block statement
		if callee.body.type is "BlockStatement"
			block = callee.body

			# make sure block has a single statement
			if block.body.length is 1
				statement = block.body[0]

				# make sure that single statement is of type "return"
				if statement.type is "ReturnStatement"
					{@sql, @params} = new Expression(statement.argument, entity, thisObject)

				else
					throw Error("Unsupported function block: expected a return statement, got #{statement.type}")

			else
				throw Error("Unsupported function block: expected a single statement, got #{block.body.length}")

		else
			throw Error("Unsupported function body: expected a block statement, got #{callee.body.type}")

module.exports = Map