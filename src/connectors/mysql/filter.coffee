esprima = require("esprima")

class Filter

	###
	Constructs a new mysql filter containing sql and parameter(s) to use in a where clause.
    @param {String} expression a javascript expression to test each entity of the entity set.
	@throw {Error} if the expression is invalid or contains an unsupported javascript clause.
    ###
	constructor: (expression) ->
		try
			ast = esprima.parse(expression)
		catch error
			throw new Error("Filter parse error: #{error.message}")
#		console.log(JSON.stringify(ast, null, 4))
		
		try
			{@sql, @params} = this._compile(ast)
		catch error
			throw error
#		console.log @sql

	###
	Compiles the given abstract syntax tree to parameterized SQL.
	@param {Object} ast the abstract syntax tree.
	@throw {Error} if ast contains an unsupported javascript clause.
	###
	_compile: (ast) ->
		sql = ""
		params = []

		switch ast.type
			when "Program"
				o = this._compile(ast.body[0])
				sql += o.sql
				params = params.concat(o.params)

			when "ExpressionStatement"
				o = this._compile(ast.expression)
				sql += o.sql
				params = params.concat(o.params)

			when "LogicalExpression"
				o = this._compile(ast.left)
				sql += "(#{o.sql})"
				params = params.concat(o.params)
				
				sql += " " + (
					switch ast.operator
						when "&&" then "AND"
						when "||" then "OR"
						else
							throw Error("Unsupported javascript operator: #{ast.operator}")
				) + " "

				o = this._compile(ast.right)
				sql += "(#{o.sql})"
				params = params.concat(o.params)

			when "BinaryExpression"# i.e. id === 2
				o = this._compile(ast.left)
				sql += o.sql
				params = params.concat(o.params)
				
#				if ast.right.type is "Literal" and ast.right.value is null

				sql += " " + (
					switch ast.operator
						when "!==", "!=" then "!="
						when "===", "==" then "="
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
							throw Error("Unsupported javascript operator: #{ast.operator}")
				) + " "
				
				o = this._compile(ast.right)
				sql += o.sql
				params = params.concat(o.params)

			when "MemberExpression"# i.e. object.property
				o = this._compile(ast.object)
				sql += o.sql + "."
				params = params.concat(o.params)

				o = this._compile(ast.property)
				sql += o.sql
				params = params.concat(o.params)

			when "Identifier"
				sql += "`#{ast.name}`"

			when "Literal"# i.e. 32
				sql += "?"
				params.push(ast.value)

			else
				throw Error("Unsupported javascript clause: #{ast.type}")

		return {sql, params}

module.exports = Filter