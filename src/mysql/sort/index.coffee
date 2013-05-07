esprima = require("esprima")
Expression = require("./expression")

class Sort

	###
	Constructs a new mysql sort to use in an order by clause.
    @param {Function} compareFunction a javascript function that defines the sort order in the entity-set.
	@throw {Error} if compareFunction contains an invalid or unsupported expression.
    ###
	constructor: (compareFunction) ->
		try
			ast = esprima.parse("sort = #{compareFunction.toString()}")
		catch error
			throw new Error("Invalid javascript expression: #{error.message}")

		# callee is on the right
		callee = ast.body[0].expression.right

		# make sure callee parameters are valid
		if callee.params.length is 2
			a = callee.params[0].name
			b = callee.params[1].name
		else
			throw Error("Invalid function parameters: expected exactly 2 parameters, got #{callee.params.length}")

		# make sure callee body is a block statement
		if callee.body.type is "BlockStatement"
			block = callee.body

			# make sure block has a single statement
			if block.body.length is 1
				statement = block.body[0]

				# make sure that single statement is of type "return"
				if statement.type is "ReturnStatement"
					{@sql, @params} = new Expression(statement.argument, a, b)

				else
					throw Error("Unsupported function block: expected a return statement, got #{statement.type}")

			else
				throw Error("Unsupported function block: expected a single statement, got #{block.body.length}")

		else
			throw Error("Unsupported function body: expected a block statement, got #{callee.body.type}")

module.exports = Sort