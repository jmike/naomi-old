esprima = require("esprima")

class Filter

	###
	Constructs a new mysql filter containing sql and parameter(s) to use in a where clause.
    @param {String} expression a javascript expression to test each entity of the entity set.
	@param {Object} attributes the attributes of the entity set to filter.
	@throw {Error} if the expression is invalid or contains an unsupported javascript clause.
    ###
	constructor: (expression, attributes) ->
		try
			ast = esprima.parse(expression)
		catch error
			throw new Error("Filter parse error: #{error.message}")
		
		try
			{@sql, @params} = this._compile(ast, attributes)
		catch error
			throw error

	###
	Compiles the given abstract syntax tree to parameterized SQL.
	@param {Object} ast the abstract syntax tree.
	@param {Object} attr the attribute(s) of the entity set.
	@throw {Error} if ast contains an unsupported javascript clause.
	###
	_compile: (ast, attr) ->
		sql = ""
		params = []

		switch ast.type
			when "Program"
				o = this._compile(ast.body[0], attr)
				sql += o.sql
				params = params.concat(o.params)

			when "ExpressionStatement"
				o = this._compile(ast.expression, attr)
				sql += o.sql
				params = params.concat(o.params)

			when "LogicalExpression"
				o = this._compile(ast.left, attr)
				sql += "(#{o.sql})"
				params = params.concat(o.params)
				
				sql += " " + (
					switch ast.operator
						when "&&" then "AND"
						when "||" then "OR"
				) + " "

				o = this._compile(ast.right, attr)
				sql += "(#{o.sql})"
				params = params.concat(o.params)

			when "BinaryExpression"# i.e. id === 2
				o = this._compile(ast.left, attr)
				sql += o.sql
				params = params.concat(o.params)
				attr = o.attr

				sql += " " + (
					switch ast.operator
						when "!==", "!=" then "!="
						when "===", "==" then "<=>"
				) + " "

				o = this._compile(ast.right, attr)
				sql += o.sql
				params = params.concat(o.params)

			when "MemberExpression"# i.e. object.property
				o = this._compile(ast.object, attr)
				sql += o.sql + "."
				params = params.concat(o.params)
				attr = o.attr

				o = this._compile(ast.property, attr)
				sql += o.sql
				params = params.concat(o.params)

			when "Identifier"
				sql += "`#{ast.name}`"
				attr = attr[ast.name]

			when "Literal"# i.e. 32
				sql += "?"
				params.push(attr.parse(ast.value, false))

			else
				throw Error("Unsupported javascript clause: #{ast.type}")

		return {sql, params, attr}

module.exports = Filter