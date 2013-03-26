esprima = require("esprima")

operators = {
	"&&": -> "AND"
	"||": -> "OR"
	"!==": (isNull) -> "!="
	"!=": (isNull) -> "!="
	"===": (isNull) -> "="
	"==": (isNull) -> "="
	">": -> ">"
	"<": -> "<"
	">=": -> ">="
	"<=": -> "<="
	"+": -> "+"
	"-": -> "-"
	"*": -> "*"
	"/": -> "/"
	"%": -> "%"
}

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
		console.log(JSON.stringify(ast, null, 4))

		try
			{@sql, @params} = this._compile(ast)
		catch error
			throw error
		console.log @sql, @params

	###
	Compiles the given abstract syntax tree to parameterized SQL.
	@param {Object} ast the abstract syntax tree.
	@param {String} entity the entity's name in the abstract syntax tree.
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	_compile: (ast, entity) ->
		sql = ""
		params = []

		switch ast.type
			when "Program"
				funct = ast.body[0].expression.right

				# make sure parameters are valid
				if funct.params.length is 1
					entity = funct.params[0].name
				else
					throw Error("Invalid function parameters: expected exactly 1 parameter, got #{funct.params.length}")

				if funct.body.type is "BlockStatement"
					block = funct.body

					# make sure block statement is valid
					if block.body.length is 1
						statement = block.body[0]

						if statement.type is "ReturnStatement"
							expression = statement.argument
						else
							throw Error("Unsupported function block: expected a return statement, got #{statement.type}")
					else
						throw Error("Unsupported function block: expected a single statement, got #{block.body.length}")
				else
					throw Error("Unsupported function body: expected a block statement, got #{funct.body.type}")

				o = this._compile(expression, entity)
				sql += o.sql
				params = params.concat(o.params)

			when "ObjectExpression"# i.e. {id: entity.id}
				for property, i in ast.properties
					if i isnt 0
						sql += ", "

					o = this._compile(property.value, entity)
					sql += o.sql
					params = params.concat(o.params)

					sql+= " AS ?"
					params.push(property.key.name)

			when "LogicalExpression", "BinaryExpression"# i.e. true || false
				left = ast.left
				right = ast.right

				isNull = (
					right.type is "Literal" and right.value is null or
					left.type is "Literal" and left.value is null
				)

				if operators.hasOwnProperty(ast.operator)
					operator = operators[ast.operator](isNull)
				else
					throw Error("Unsupported javascript operator: #{ast.operator}")

				sql += "("
				o = this._compile(left, entity)
				sql += o.sql
				params = params.concat(o.params)

				sql += " #{operator} "

				o = this._compile(right, entity)
				sql += o.sql
				params = params.concat(o.params)
				sql += ")"

			when "MemberExpression"# i.e. object.property
				object = ast.object
				property = ast.property

				if object.name is entity# i.e. "entity.name"
					o = this._compile(property)
					sql += o.sql
					params = params.concat(o.params)
				else
					o = this._compile(object, entity)
					sql += o.sql + "."
					params = params.concat(o.params)

					o = this._compile(property, entity)
					sql += o.sql
					params = params.concat(o.params)

			when "Identifier"
				sql += "`#{ast.name}`"

			when "Literal"# i.e. 32
				sql += "?"
				params.push(ast.value)

			else
				throw Error("Unsupported javascript expression: #{ast.type}")

		return {sql, params}

module.exports = Map