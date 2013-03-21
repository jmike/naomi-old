esprima = require("esprima")
_ = require("underscore")

class Sort

	###
	Constructs a new mysql sort to use in an order by clause.
    @param {String} expression a javascript expression that defines the sort order.
	@param {String} a the current entity's name in the given expression (optional), defaults to "a".
	@param {String} b the next entity's name in the given expression (optional), defaults to "b".
	@throw {Error} if the expression is invalid or unsupported.
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
	Returns true if the supplied objects are comparable, false if not.
	@param {Object} x as taken from the abstract syntax tree.
	@param {Object} y as taken from the abstract syntax tree.
	@param {String} a the current entity's name in the abstract syntax tree.
	@param {String} b the next entity's name in the abstract syntax tree.
	@return {Boolean}
	###
	_isComparable: (x, y, a, b) ->
		x.type is "MemberExpression" and
		y.type is "MemberExpression" and (
			x.object.name is a and y.object.name is b or
			x.object.name is b and y.object.name is a
		) and _.isEqual(x.property, y.property)

	###
	Compiles the given abstract syntax tree to parameterized SQL.
	@param {Object} ast the abstract syntax tree.
	@param {String} a the current entity's name in the abstract syntax tree.
	@param {String} b the next entity's name in the abstract syntax tree.
	@throw {Error} if ast contains an invalid or unsupported javascript clause.
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

			when "CallExpression"
				callee = ast.callee
				args = ast.arguments

				if callee.type is "MemberExpression"
					object = callee.object
					property = callee.property

					if property.name is "localCompare"
						if args.length isnt 1
							throw new Error("Invalid argument length: expected exactly one (1) argument")

						if this._isComparable(object, args[0], a, b)
							o = this._compile(object, a, b)
							sql += o.sql
							params = params.concat(o.params)

							sql += " " + (
								if object.object.name is a
									"ASC"
								else
									"DESC"
							)

						else
							throw Error("Uncomparable javascript members")
					else
						throw Error("Unsupported javascript function: #{property.name}")
				else
					throw Error("Unsupported javascript call")

			when "BinaryExpression"# i.e. a.id - b.id
				left = ast.left
				operator = ast.operator
				right = ast.right

				if operator is "-"
					if this._isComparable(left, right, a, b)
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
						throw Error("Uncomparable javascript members")
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