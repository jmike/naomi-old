esprima = require("esprima")

class Filter

	###
	Creates a new mysql filter to use in a where clause.
    @param {Object} attributes the attributes of the entity set to filter.
    @param {String} expression a javascript expression to test each entity of the entity set.
	@note The current entity in the javascript expression should always be identifies as "entity", e.g. "entity.id === 1".
	@throw {Error} if the expression cannot be parsed.
    ###
	constructor: (attributes, expression) ->
		try
			ast = esprima.parse(expression)
		catch error
			throw new Error("Filter parse error: #{error.message}")
		
		@attributes = attributes
		@sql = ""
		@params = []
		
		this._compile(ast)

		console.log(JSON.stringify(ast, null, 4))
		console.log this

	###
	###
	_compile: (ast) ->
		switch ast.type
			when "Program"
				for e in ast.body
					this._compile(e)
			when "ExpressionStatement"
				this._compile(ast.expression)
			when "BinaryExpression"
				this._compile(ast.left)
				@sql += (
					switch ast.operator
						when "!==", "!="
							" != "
				)
				this._compile(ast.right)
			when "MemberExpression"
				this._compile(ast.object)
				@sql += "."
				this._compile(ast.property)
			when "Identifier"
				@sql += "`#{ast.name}`"
			when "Literal"
				@sql += "?"
				@params.push(ast.value)
			else
				throw Error("Unsupported javascript clause: #{ast.type}")
		return

module.exports = Filter