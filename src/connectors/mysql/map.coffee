esprima = require("esprima")
Expression = require("./expression")

class Map

	###
	Constructs a new mysql map to use in a select clause.
    @param {Function} callback a function that produces a new entity.
	@param {Object} thisArg Object to use as this when executing callback.
	@throw {Error} if callback contains an invalid or unsupported expression.
    ###
	constructor: (callback, thisArg) ->
		try
			ast = esprima.parse("map = #{callback.toString()}")
		catch error
			throw new Error("Invalid javascript expression: #{error.message}")

		try
			{@sql, @params} = this._compile(ast)
		catch error
			throw error

	###
	Compiles the given abstract syntax tree to parameterized SQL.
	@param {Object} ast the abstract syntax tree.
	@param {String} entity the entity's name in the abstract syntax tree.
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	_compile: (ast, entity) ->
		funct = ast.body[0].expression.right

		# make sure function parameters are valid
		if funct.params.length is 1
			entity = funct.params[0].name
		else
			throw Error("Invalid function parameters: expected exactly 1 parameter, got #{funct.params.length}")

		# make sure function body is a block
		if funct.body.type is "BlockStatement"
			block = funct.body

			# make sure block has a single statement
			if block.body.length is 1
				statement = block.body[0]

				# make sure the statement is of type "return"
				if statement.type is "ReturnStatement"
#					console.log(JSON.stringify(statement.argument, null, 4))
					return new Expression(statement.argument, entity)

				else
					throw Error("Unsupported function block: expected a return statement, got #{statement.type}")

			else
				throw Error("Unsupported function block: expected a single statement, got #{block.body.length}")

		else
			throw Error("Unsupported function body: expected a block statement, got #{funct.body.type}")

module.exports = Map