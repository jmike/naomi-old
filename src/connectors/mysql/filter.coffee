esprima = require("esprima")

class Filter

	###
	Constructs a new mysql filter to use in a where clause.
    @param {String} expression a javascript expression to test each entity of the entity set.
	@param {String} entity the entity's name in the given expression (optional), defaults to plain "entity".
	@throw {Error} if the expression is invalid or unsupported.
    ###
	constructor: (expression, entity = "entity") ->
		try
			ast = esprima.parse(expression)
		catch error
			throw new Error("Invalid javascript expression: #{error.message}")
#		console.log(JSON.stringify(ast, null, 4))

		try
			{@sql, @params} = this._compile(ast, entity)
		catch error
			throw error
#		console.log @sql, @params

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
			when "Program"
				o = this._compile(ast.body[0], entity)
				sql += o.sql
				params = params.concat(o.params)

			when "ExpressionStatement"
				o = this._compile(ast.expression, entity)
				sql += o.sql
				params = params.concat(o.params)

			when "CallExpression"
				callee = ast.callee
				args = ast.arguments

				if callee.type is "MemberExpression"
					object = callee.object
					property = callee.property

					if object.name is "Math"
						switch property.name
							when "abs" then sql += "ABS"
							when "acos" then sql += "ACOS"
							when "asin" then sql += "ASIN"
							when "atan" then sql += "ATAN"
							when "atan2" then sql += "ATAN2"
							when "ceil" then sql += "CEIL"
							when "cos" then sql += "COS"
							when "exp" then sql += "EXP"
							when "floor" then sql += "FLOOR"
							when "log" then sql += "LOG"
							when "pow" then sql += "POW"
							when "random" then sql += "RAND"
							when "round" then sql += "ROUND"
							when "sin" then sql += "SIN"
							when "sqrt" then sql += "SQRT"
							when "tan" then sql += "TAN"
							else
								throw Error("Unsupported math property: #{property.name}")

						sql += "("
						for arg, i in args
							if i isnt 0
								sql += ", "
							o = this._compile(arg, entity)
							sql += o.sql
							params = params.concat(o.params)
						sql += ")"

					else if property.name in ["contains", "startsWith", "endsWith"]
						o = this._compile(object, entity)
						sql += o.sql
						params = params.concat(o.params)

						sql += " LIKE "

						if args.length is 1
							o = this._compile(args[0], entity)
							sql += o.sql
							switch property.name
								when "contains"
									params.push("%#{o.params[0]}%")
								when "startsWith"
									params.push("#{o.params[0]}%")
								when "endsWith"
									params.push("%#{o.params[0]}")
						else
							throw Error("Invalid argument length")

					else
						throw Error("Unsupported javascript object: #{callee.object.name}")

				else
					throw Error("Unsupported call expression")

			when "LogicalExpression"# i.e. true || false
				left = ast.left
				operator = ast.operator
				right = ast.right

				o = this._compile(left, entity)
				sql += "(#{o.sql})"
				params = params.concat(o.params)

				sql += " " + (
					switch operator
						when "&&" then "AND"
						when "||" then "OR"
						else
							throw Error("Unsupported javascript operator: #{operator}")
				) + " "

				o = this._compile(right, entity)
				sql += "(#{o.sql})"
				params = params.concat(o.params)

			when "BinaryExpression"# i.e. id === 2
				left = ast.left
				operator = ast.operator
				right = ast.right

				o = this._compile(left, entity)
				sql += o.sql
				params = params.concat(o.params)

				sql += " " + (
					switch operator
						when "!==", "!="
							if right.type is "Literal" and right.value is null or
							left.type is "Literal" and left.value is null
								"IS NOT"
							else
								"!="
						when "===", "=="
							if right.type is "Literal" and right.value is null or
							left.type is "Literal" and left.value is null
								"IS"
							else
								"="
						when ">" then ">"
						when "<" then "<"
						when ">=" then ">="
						when "<=" then "<="
						when "+" then "+"
						when "-" then "-"
						when "*" then "*"
						when "/" then "/"
						when "%" then "%"
						else
							throw Error("Unsupported javascript operator: #{operator}")
				) + " "

				o = this._compile(right, entity)
				sql += o.sql
				params = params.concat(o.params)

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

module.exports = Filter