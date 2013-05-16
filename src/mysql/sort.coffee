esprima = require("esprima")
_ = require("underscore")

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
					{@sql, @params} = new Sort.Expression(statement.argument, a, b)

				else
					throw Error("Unsupported function block: expected a return statement, got #{statement.type}")

			else
				throw Error("Unsupported function block: expected a single statement, got #{block.body.length}")

		else
			throw Error("Unsupported function body: expected a block statement, got #{callee.body.type}")

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

class Sort.Expression

	###
	Constructs a parameterized SQL expression from given abstract syntax tree.
	@param {Object} ast the abstract syntax tree.
	@param {String} a reference to the current entity's instance in the abstract syntax tree.
	@param {String} b reference to the next entity's instance in the abstract syntax tree.
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast, a = "a", b = "b") ->
		if Sort.hasOwnProperty(ast.type)
			{@sql, @params} = new Sort[ast.type](ast, a, b)
		else
			throw Error("Unsupported javascript expression: #{ast.type}")

class Sort.Identifier

	###
	Constructs a parameterized SQL expression from given abstract syntax tree containing an identifier.
	@param {Object} ast the abstract syntax tree.
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast) ->
		@sql = "??"
		@params = [ast.name]

class Sort.MemberExpression

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
			{@sql, @params} = new Sort.Expression(property, "", "")

		else# e.g. object.name
			expr = new Sort.Expression(object, a, b)
			sql = expr.sql
			params = expr.params

			sql += "."

			expr = new Sort.Expression(property, a, b)
			sql += expr.sql
			params = params.concat(expr.params)

			@sql = sql
			@params = params

class Sort.BinaryExpression

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

		if Sort._isComparable(left, right, a, b)

			if operator is "-"
				{sql, params} = new Sort.Expression(left, a, b)

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

class Sort.CallExpression

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

					if Sort._isComparable(object, args[0], a, b)
						{sql, params} = new Sort.Expression(object, a, b)

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

module.exports = Sort