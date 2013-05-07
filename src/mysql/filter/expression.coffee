class Expression

	###
	Constructs a parameterized SQL expression from given abstract syntax tree.
	@param {Object} ast the abstract syntax tree.
	@param {String} entity the entity's name in the abstract syntax tree (optional), defaults to "entity".
	@param {Object} thisObject object to use as this (optional).
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast, entity = "entity", thisObject) ->
		Expr = Expression[ast.type]
		if Expr?
			{@sql, @params} = new Expr(ast, entity, thisObject)
		else
			throw Error("Unsupported javascript expression: #{ast.type}")

class Expression.Identifier

	###
	Constructs a parameterized SQL expression from given abstract syntax tree containing an identifier.
	@param {Object} ast the abstract syntax tree.
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast) ->
		@sql = "??"
		@params = [ast.name]

class Expression.Literal

	###
	Constructs a parameterized SQL expression from given abstract syntax tree containing a literal, e.g. 32.
	@param {Object} ast the abstract syntax tree.
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast) ->
		@sql = "?"
		@params = [ast.value]

class Expression.MemberExpression

	###
	Constructs a parameterized SQL expression from given abstract syntax tree containing a member expression, e.g. object.property.
	@param {Object} ast the abstract syntax tree.
	@param {String} entity the entity's name in the abstract syntax tree (optional), defaults to "entity".
	@param {Object} thisObject object to use as this (optional).
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast, entity = "entity", thisObject) ->
		object = ast.object
		property = ast.property

		if object.name is entity # e.g. entity.object.name
		 	{@sql, @params} = new Expression(property, "", thisObject)

		else if object.type is "ThisExpression"# e.g. this.age
			if thisObject? and thisObject.hasOwnProperty(property.name)
				@sql = "?"
				@params = [thisObject[property.name]]

			else
				throw new Error("Undefined property #{property.name} of 'this' object")

		else# e.g. object.name
			expr = new Expression(object, entity, thisObject)
			sql = expr.sql
			params = expr.params

			sql += "."

			expr = new Expression(property, entity, thisObject)
			sql += expr.sql
			params = params.concat(expr.params)

			@sql = sql
			@params = params

class Expression.LogicalExpression

	###
	Constructs a parameterized SQL expression from given abstract syntax tree containing a logical expression, e.g. true || false.
	@param {Object} ast the abstract syntax tree.
	@param {String} entity the entity's name in the abstract syntax tree (optional), defaults to "entity".
	@param {Object} thisObject object to use as this (optional).
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast, entity = "entity", thisObject) ->
		left = ast.left
		operator = ast.operator
		right = ast.right

		if this._operators.hasOwnProperty(operator)
			sql = ""
			params = []

			sql += "("
			expr = new Expression(left, entity, thisObject)
			sql += expr.sql
			params = params.concat(expr.params)

			sql += " #{this._operators[operator]} "

			expr = new Expression(right, entity, thisObject)
			sql += expr.sql
			params = params.concat(expr.params)
			sql += ")"

			@sql = sql
			@params = params

		else
			throw Error("Unsupported javascript operator: #{ast.operator}")

	_operators: {
		"&&": "AND"
		"||": "OR"
	}

class Expression.BinaryExpression

	###
	Constructs a parameterized SQL expression from given abstract syntax tree containing a binary expression, e.g. 1 + 1.
	@param {Object} ast the abstract syntax tree.
	@param {String} entity the entity's name in the abstract syntax tree (optional), defaults to "entity".
	@param {Object} thisObject object to use as this (optional).
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast, entity = "entity", thisObject) ->
		left = ast.left
		operator = ast.operator
		right = ast.right

		# Make sure literals are always on the right
		if right.type isnt "Literal" and left.type is "Literal"
			left = ast.right
			right = ast.left

		# Indicate whether on of literal values is null
		isNull = (
			right.type is "Literal" and right.value is null or
			left.type is "Literal" and left.value is null
		)

		if this._operators.hasOwnProperty(operator)
			sql = ""
			params = []

			sql += "("
			expr = new Expression(left, entity, thisObject)
			sql += expr.sql
			params = params.concat(expr.params)

			sql += " #{this._operators[operator](isNull)} "

			expr = new Expression(right, entity, thisObject)
			sql += expr.sql
			params = params.concat(expr.params)
			sql += ")"

			@sql = sql
			@params = params

		else
			throw Error("Unsupported javascript operator: #{ast.operator}")

	_operators: {
		"!==": (isNull) ->
			if isNull
				return "IS NOT"
			else
				return "!="

		"!=": (isNull) ->
			if isNull
				return "IS NOT"
			else
				return "!="

		"===": (isNull) ->
			if isNull
				return "IS"
			else
				return "="

		"==": (isNull) ->
			if isNull
				return "IS"
			else
				return "="

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

class Expression.CallExpression

	###
	Constructs a parameterized SQL expression from given abstract syntax tree containing a call expression, e.g. Math.sin(variable).
	@param {Object} ast the abstract syntax tree.
	@param {String} entity the entity's name in the abstract syntax tree (optional), defaults to "entity".
	@param {Object} thisObject object to use as this (optional).
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast, entity = "entity", thisObject) ->
		callee = ast.callee
		args = ast.arguments

		if callee.type is "MemberExpression"
			object = callee.object
			property = callee.property

			if object.name is "Math"

				if this._math.hasOwnProperty(property.name)
					sql = this._math[property.name]
					params = []

					sql += "("
					for arg, i in args
						if i isnt 0 then sql += ", "
						expr = new Expression(arg, entity, thisObject)
						sql += expr.sql
						params = params.concat(expr.params)
					sql += ")"

					@sql = sql
					@params = params

				else
					throw Error("Unsupported math function: #{property.name}")

			else if this._string.hasOwnProperty(property.name)
				sql = ""
				params = []

				sql += "("
				expr = new Expression(object, entity, thisObject)
				sql += expr.sql
				params = params.concat(expr.params)

				sql += " LIKE "

				expr = new Expression(args[0], entity, thisObject)
				str = this._string[property.name](expr.params[0])
				sql += expr.sql
				params = params.concat(str)
				sql += ")"

				@sql = sql
				@params = params

			else
				throw Error("Unsupported callee object: #{callee.object.name}")

		else
			throw Error("Unsupported call expression")

	_math: {
		abs: "ABS"
		acos: "ACOS"
		asin: "ASIN"
		atan: "ATAN"
		atan2: "ATAN2"
		ceil: "CEIL"
		cos: "COS"
		exp: "EXP"
		floor: "FLOOR"
		log: "LOG"
		pow: "POW"
		random: "RAND"
		round: "ROUND"
		sin: "SIN"
		sqrt: "SQRT"
		tan: "TAN"
	}

	_string: {
		contains: (str) -> "%#{str}%"
		startsWith: (str) -> "#{str}%"
		endsWith: (str) -> "%#{str}"
	}

module.exports = Expression