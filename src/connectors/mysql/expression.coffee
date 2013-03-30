class Expression

	###
	Constructs a parameterized SQL expression from given abstract syntax tree.
	@param {Object} ast the abstract syntax tree.
	@param {String} entity the entity's name in the abstract syntax tree (optional), defaults to "entity".
	@param {Object} thisObject object to use as this (optional).
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast, entity = "entity", thisObject) ->
		CustomExpression = Expression[ast.type]
		if CustomExpression?
			{@sql, @params} = new CustomExpression(ast, entity, thisObject)
		else
			throw Error("Unsupported javascript expression: #{ast.type}")

class Expression.Identifier

	###
	Constructs a parameterized SQL expression from given abstract syntax tree containing an identifier.
	@param {Object} ast the abstract syntax tree.
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast) ->
		@sql = "`#{ast.name}`"
		@params = []

class Expression.Literal

	###
	Constructs a parameterized SQL expression from given abstract syntax tree containing a literal, i.e. 32.
	@param {Object} ast the abstract syntax tree.
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast) ->
		@sql = "?"
		@params = [ast.value]

class Expression.MemberExpression

	###
	Constructs a parameterized SQL expression from given abstract syntax tree containing a member expression, i.e. object.property.
	@param {Object} ast the abstract syntax tree.
	@param {String} entity the entity's name in the abstract syntax tree (optional), defaults to "entity".
	@param {Object} thisObject object to use as this (optional).
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast, entity = "entity", thisObject) ->
		object = ast.object
		property = ast.property

		switch object.name
			when entity
				{@sql, @params} = new Expression(property, "", thisObject)

			when "this"
				throw new Error("Keyword 'this' is not yet supported")

			else
				expression = new Expression(object, entity, thisObject)
				sql = expression.sql
				params = expression.params

				sql += "."

				expression = new Expression(property, entity, thisObject)
				sql += expression.sql
				params = params.concat(expression.params)

				@sql = sql
				@params = params

class Expression.LogicalExpression

	###
	Constructs a parameterized SQL expression from given abstract syntax tree containing a logical expression, i.e. true || false.
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
			expression = new Expression(left, entity, thisObject)
			sql += expression.sql
			params = params.concat(expression.params)

			sql += " #{this._operators[operator]} "

			expression = new Expression(right, entity, thisObject)
			sql += expression.sql
			params = params.concat(expression.params)
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
	Constructs a parameterized SQL expression from given abstract syntax tree containing a binary expression, i.e. 1 + 1.
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
			expression = new Expression(left, entity, thisObject)
			sql += expression.sql
			params = params.concat(expression.params)

			isNull = (
				right.type is "Literal" and right.value is null or
				left.type is "Literal" and left.value is null
			)
			sql += " #{this._operators[operator](isNull)} "

			expression = new Expression(right, entity, thisObject)
			sql += expression.sql
			params = params.concat(expression.params)
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
	Constructs a parameterized SQL expression from given abstract syntax tree containing a call expression, i.e. Math.sin(variable).
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
						expression = new Expression(arg, entity, thisObject)
						sql += expression.sql
						params = params.concat(expression.params)
					sql += ")"

					@sql = sql
					@params = params
				else
					throw Error("Unsupported math function: #{property.name}")

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

class Expression.ObjectExpression

	###
	Constructs a parameterized SQL expression from given abstract syntax tree containing a call expression, i.e. {id: entity.id}.
	@param {Object} ast the abstract syntax tree.
	@param {String} entity the entity's name in the abstract syntax tree (optional), defaults to "entity".
	@param {Object} thisObject object to use as this (optional).
	@throw {Error} if ast contains an invalid or unsupported expression.
	###
	constructor: (ast, entity = "entity", thisObject) ->
		sql = ""
		params = []

		for property, i in ast.properties
			if i isnt 0 then sql += ", "

			expression = new Expression(property.value, entity)
			sql += expression.sql
			params = params.concat(expression.params)

			sql+= " AS ?"
			params.push(property.key.name)

		@sql = sql
		@params = params

module.exports = Expression