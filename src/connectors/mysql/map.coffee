esprima = require("esprima")

class Map

	###
	Constructs a new mysql map to use in a select clause.
    @param {String} expression a javascript expression to specify a new entity to return.
	@param {String} entity the entity's name in the given expression (optional), defaults to plain "entity".
	@throw {Error} if the expression is invalid or unsupported.
    ###
	constructor: (expression, entity = "entity") ->
		try
			ast = esprima.parse(expression)
		catch error
			throw new Error("Invalid javascript expression: #{error.message}")
		console.log(JSON.stringify(ast, null, 4))

		try
			{@sql, @params} = this._compile(ast, entity)
		catch error
			throw error
		console.log @sql, @params

	###
	Compiles the given abstract syntax tree to parameterized SQL.
	@param {Object} ast the abstract syntax tree.
	@param {String} entity the entity's name in the abstract syntax tree.
	@throw {Error} if ast contains an invalid or unsupported javascript clause.
	###
	_compile: (ast, entity = "") ->
		sql = ""
		params = []

		switch ast.type
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