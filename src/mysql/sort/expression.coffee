_ = require("underscore")

class Expression

	###
	Constructs a parameterized SQL expression from given abstract syntax tree.
	@param {Object} ast the abstract syntax tree.
	@param {String} a reference to the current entity's instance in the abstract syntax tree.
	@param {String} b reference to the next entity's instance in the abstract syntax tree.
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast, a = "a", b = "b") ->
		Expr = Expression[ast.type]
		if Expr?
			{@sql, @params} = new Expr(ast, a, b)
		else
			throw Error("Unsupported javascript expression: #{ast.type}")

	###
	Returns true if the supplied objects are comparable, false if not.
	@param {Object} x as taken from the abstract syntax tree.
	@param {Object} y as taken from the abstract syntax tree.
	@param {String} a reference to the current entity's instance in the abstract syntax tree.
	@param {String} b reference to the next entity's instance in the abstract syntax tree.
	@return {Boolean}
	###
	@_isComparable: (x, y, a, b) ->
		x.type is y.type is "MemberExpression" and (
			x.object.name is a and y.object.name is b or
			x.object.name is b and y.object.name is a
		) and _.isEqual(x.property, y.property)

class Expression.Identifier

	###
	Constructs a parameterized SQL expression from given abstract syntax tree containing an identifier.
	@param {Object} ast the abstract syntax tree.
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast) ->
		@sql = "??"
		@params = [ast.name]

class Expression.MemberExpression

	###
	Constructs a parameterized SQL expression from given abstract syntax tree containing a member expression, e.g. object.property.
	@param {Object} ast the abstract syntax tree.
	@param {String} a reference to the current entity's instance in the abstract syntax tree.
	@param {String} b reference to the next entity's instance in the abstract syntax tree.
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast, a = "a", b = "b") ->
		object = ast.object
		property = ast.property

		if object.name in [a, b]# e.g. "a.object.name" or "b.name"
			{@sql, @params} = new Expression(property, "", "")

		else# e.g. object.name
			expr = new Expression(object, a, b)
			sql = expr.sql
			params = expr.params

			sql += "."

			expr = new Expression(property, a, b)
			sql += expr.sql
			params = params.concat(expr.params)

			@sql = sql
			@params = params

class Expression.BinaryExpression

	###
	Constructs a parameterized SQL expression from given abstract syntax tree containing a binary expression, e.g. a.id - b.id.
	@param {Object} ast the abstract syntax tree.
	@param {String} a reference to the current entity's instance in the abstract syntax tree.
	@param {String} b reference to the next entity's instance in the abstract syntax tree.
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast, a = "a", b = "b") ->
		left = ast.left
		operator = ast.operator
		right = ast.right

		if Expression._isComparable(left, right, a, b)

			if operator is "-"
				{sql, params} = new Expression(left, a, b)

				sql += " " + (
					if left.object.name is a
						"ASC"
					else
						"DESC"
				)

				@sql = sql
				@params = params

			else
				throw Error("Unsupported javascript operator: #{ast.operator}")

		else
			throw Error("Uncomparable javascript members")

class Expression.CallExpression

	###
	Constructs a parameterized SQL expression from given abstract syntax tree containing a call expression, e.g. Math.sin(variable).
	@param {Object} ast the abstract syntax tree.
	@param {String} a reference to the current entity's instance in the abstract syntax tree.
	@param {String} b reference to the next entity's instance in the abstract syntax tree.
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast, a = "a", b = "b") ->
		callee = ast.callee
		args = ast.arguments

		if callee.type is "MemberExpression"
			object = callee.object
			property = callee.property

			if property.name is "localeCompare"

				if args.length is 1

					if Expression._isComparable(object, args[0], a, b)
						{sql, params} = new Expression(object, a, b)

						sql += " " + (
							if object.object.name is a
								"ASC"
							else
								"DESC"
						)

						@sql = sql
						@params = params

					else
						throw Error("Uncomparable javascript members")

				else
					throw Error("Invalid argument length: exprected a single argument, got #{args.length}")

			else
				throw Error("Unsupported method call: #{property.name}")

		else
			throw Error("Unsupported call expression")

module.exports = Expression