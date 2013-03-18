esprima = require("esprima")
_ = require("underscore")

class Sort

	###
	Constructs a new mysql sort statement to use in an order by clause.
    @param {String} expression a javascript expression that defines the sort order.
	@param {String} a the current entity's identifier in the given expression (optional), defaults to "a".
	@param {String} b the next entity's identifier in the given expression (optional), defaults to "b".
	@throw {Error} if the expression is invalid or contains an unsupported javascript clause.
    ###
	constructor: (expression, a = "a", b = "b") ->
		try
			ast = esprima.parse(expression)
		catch error
			throw new Error("Sort parse error: #{error.message}")
#		console.log(JSON.stringify(ast, null, 4))

		try
			{@sql, @params} = this._compile(ast, a, b)
		catch error
			throw error
#		console.log @sql, @params

	###
	Compiles the given abstract syntax tree to parameterized SQL.
	@param {Object} ast the abstract syntax tree.
	@param {String} a the current entity's identifier in the abstract syntax tree.
	@param {String} b the next entity's identifier in the abstract syntax tree.
	@throw {Error} if ast contains an unsupported javascript clause.
	###
	_compile: (ast, a = "", b = "") ->
		sql = ""
		params = []

		switch ast.type
			when "Program"
				o = this._compile(ast.body[0], a, b)
				sql += o.sql
				params = params.concat(o.params)

			when "ExpressionStatement"
				o = this._compile(ast.expression, a, b)
				sql += o.sql
				params = params.concat(o.params)

			when "BinaryExpression"# i.e. a.id - b.id
				left = ast.left
				operator = ast.operator
				right = ast.right

				if left.type isnt "MemberExpression"
					throw Error("Expected MemberExpression, got #{left.type}")
				if right.type isnt "MemberExpression"
					throw Error("Expected MemberExpression, got #{right.type}")

				if left.object.name not in [a, b]
					throw Error("Unknown object: #{left.object.name}")
				if right.object.name not in [a, b]
					throw Error("Unknown object: #{right.object.name}")

				if left.object.name is right.object.name
					throw Error("Compared properties are of the same object")
				if not _.isEqual(left.property, right.property)
					throw Error("Expected property of object #{a} to be equal to property of object #{b}")

				if operator is "-"
					o = this._compile(left, a, b)
					sql += o.sql
					params = params.concat(o.params)

					sql += " " + (
						if left.object.name is a
							"ASC"
						else
							"DESC"
					)
				else
					throw Error("Unsupported javascript operator: #{operator}")

			when "MemberExpression"# i.e. object.property
				object = ast.object
				property = ast.property

				if object.name in [a, b]# i.e. "a.name" or "b.name"
					o = this._compile(property)
					sql += o.sql
					params = params.concat(o.params)

				else
					o = this._compile(object, a, b)
					sql += o.sql + "."
					params = params.concat(o.params)

					o = this._compile(property, a, b)
					sql += o.sql
					params = params.concat(o.params)

			when "Identifier"
				sql += "`#{ast.name}`"

			else
				throw Error("Unsupported javascript expression: #{ast.type}")

		return {sql, params}

module.exports = Sort