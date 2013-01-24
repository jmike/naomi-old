###
Query is a handy class that can be used to create complex queries.
###
class Query
	
	###
	Constructs a new Query instance with the specified attributes.
	@param {String|Array<String>} the name of the attribute and it's optional corresponding alias name, i.e. "field" or "["field", "alias"].
	@return {Query} to allow method chaining.
	###
	@show: (args...) ->
		q = new Query()
		q.show.apply(q, args)
		return q
		
	@filter: (args...) ->
		q = new Query()
		q.filter.apply(q, args)
		return q
		
	@and: (args...) ->
		x = Object.create(Query.And.prototype)
		Query.And.apply(x, args)
		return x
		
	@or: (args...) ->
		x = Object.create(Query.Or.prototype)
		Query.Or.apply(x, args)
		return x
	
	@order: (args...) ->
		q = new Query()
		q.order.apply(q, args)
		return q
	
	@offset: (n) -> new Query().offset(n)
	
	@limit: (n) -> new Query().limit(n)
	
	###
	Constructs a new Query instance.
	###
	constructor: ->
		@_properties = {}

	###
	Specifies the attributes to include in the query.
	@param {String|Array<String>} the name of the attribute and it's optional corresponding alias name, i.e. "field" or "["field", "alias"].
	@return {Query} to allow method chaining.
	###
	show: (args...) ->
		x = Object.create(Query.Show.prototype)
		Query.Show.apply(x, args)
		@_properties.show = x.expression		
		return this

	###
	Filters the query results with the designated expressions.
	@param {String, Array.<String>} accepts multiple parameters.
	@return {Query} to allow method chaining.
	###
	filter: (args...) ->
		x = Object.create(Query.Filter.prototype)
		Query.Filter.apply(x, args)
		@_properties.filter = x.expression
		return this
	
	###
	Orders the query results with the designated expressions.
	@param {String, Array.<String>} accepts multiple parameters.
	@return {Query} to allow method chaining.
	###
	order: (args...) ->
		x = Object.create(Query.Order.prototype)
		Query.Order.apply(x, args)
		@_properties.order = x.expression
		return this

	###
	Excludes the designated number of records from the query.
	@param {number} n non-negative integer (including zero).
	@return {Query} to allow method chaining.
	###
	offset: (n) ->
		if typeof n is "number" and n % 1 is 0 and n >= 0
			@_properties.offset = n
		else
			throw new Error("Invalid or unspecified offset")
		return this

	###
	Limits the query results.
	@param {number} n non-negative integer (including zero).
	@return {Query} to allow method chaining.
	###
	limit: (n) ->
		if typeof n is "number" and n % 1 is 0 and n >= 0
			@_properties.limit = n
		else
			throw new Error("Invalid or unspecified limit")
		return this

	toJSON: -> @_properties

###
@private
###
class Query.Show

	###
	Constructs a new show expression.
	###
	constructor: (args...) -> 
		@expression = []
		if args.length is 0
			throw new Error("You must specify at least one show parameter")
		for x in args
			if typeof x is "string"
				@expression.push(new Query.Show.Clause(x))
			else if Array.isArray(x)
				@expression.push(new Query.Show.Clause(x[0], x[1]))
			else
				throw new Error("Invalid show parameter - expected String or Array, got #{typeof x}")

###
@private
###
class Query.Show.Clause
	
	###
	Constructs a new show clause.
	@param {String} key the name of the column to show.
	@param {String} alias a new (probably easier) name to reference the column (optional).
	###
	constructor: (key, alias = null) ->
		if typeof key isnt "string"
			throw new Error("Invalid show key - expected String, got #{typeof key}")
		if alias? and typeof alias isnt "string"
			throw new Error("Invalid alias - expected String, got #{typeof alias}")
		@key = key
		@alias = alias

###
@private
###
class Query.Order
	
	###
	Constructs a new order expression.
	###
	constructor: (args...) ->
		@expression = []
		for x in args
			if typeof x is "string"
				@expression.push(new Query.Order.Clause(x))
			else if Array.isArray(x)
				@expression.push(new Query.Order.Clause(x[0], x[1]))
			else
				throw new Error("Invalid order parameter - expected String or Array, got #{typeof x}")

###
@private
###
class Query.Order.Clause

	###
	Constructs a new order clause.
	@param {String} key the name of the column to order.
	@param {String} type the type of the order, either "ASC" or "DESC".
	###
	constructor: (key, type = "ASC") ->
		if typeof key isnt "string"
			throw new Error("Invalid order key - expected String, got #{typeof key}")
		if typeof type isnt "string"
			throw new Error("Invalid order type - expected String, got #{typeof type}")
		unless /^(?:ASC|DESC)$/i.test(type)
			throw new Error("Invalid order type - expected either 'ASC' or 'DESC', got #{value}")
		@key = key
		@type = type.toUpperCase()

class Query.And

	constructor: (args...) ->
		@expression = []
		if args.length < 2
			throw new Error("You must specify at least two filter parameters to apply a logical AND")
		else
			for x in args
				if typeof x is "string"
					@expression.push(new Query.Filter.Clause(x))
				else if Array.isArray(x)
					@expression.push(new Query.Filter.Clause(x[0], x[1], x[2]))
				else if x instanceof Query.Or
					@expression.push({
						"or": x.expression
					})
				else
					throw new Error("Invalid 'AND' expression parameter - expected String or Array or Query.Or, got #{typeof x}")

class Query.Or

	constructor: (args...) ->
		@expression = []
		if args.length < 2
			throw new Error("You must specify at least two filter parameters to apply a logical OR")
		else
			for x in args
				if typeof x is "string"
					@expression.push(new Query.Filter.Clause(x))
				else if Array.isArray(x)
					@expression.push(new Query.Filter.Clause(x[0], x[1], x[2]))
				else if x instanceof Query.And
					@expression.push({
						"and": x.expression
					})
				else
					throw new Error("Invalid 'OR' expression parameter - expected String or Array or Query.And, got #{typeof x}")

###
@private
###
class Query.Filter
	
	###
	Constructs a new filter expression.
	###
	constructor: (args...) ->
		if args.length is 0
			throw new Error("You must specify at least one filter parameter")
		if args.length > 1
			x = Object.create(Query.And.prototype)
			Query.And.apply(x, args)
			@expression = {
				"and": x.expression
			}			
		else
			x = args[0]
			if typeof x is "string"
				@expression = new Query.Filter.Clause(x)
			else if Array.isArray(x)
				@expression = new Query.Filter.Clause(x[0], x[1], x[2])
			else if x instanceof Query.And
				@expression = {
					"and": x.expression
				}
			else if x instanceof Query.Or
				@expression = {
					"or": x.expression
				}
			else
				throw new Error("Invalid 'and' expression parameter - expected String or Array or Query.OR, got #{typeof x}")

###
@private
###
class Query.Filter.Clause
	
	###
	Constructs a new filter clause.
	@param {String} key the name of the column to filter.
	@param {String} operator the filter operator.
	@param {String} value the filter value.
	###
	constructor: (key, operator = "!=", value = null) ->
		if typeof key isnt "string"
			throw new Error("Invalid filter key - expected String, got #{typeof key}")
		if typeof operator isnt "string"
			throw new Error("Invalid filter operator - expected String, got #{typeof operator}")
		if operator not in ["!=", "=", ">=", "<=", ">", "<", "~"]
			throw new Error("Invalid filter operator")
		@key = key
		@operator = operator
		@value = value
		
AND = Query.and
OR = Query.or

q = Query.show(
	"name"
	"id"
	["age", "years old"]
).filter(
	AND(
		["id", ">", "10"]
		OR(
			["name", "=", "mitsos"]
			["name", "=", "kitsos"]
		)
		["age", "=", "29"]
	)
).order(
	"name"
	["id", "DESC"]
	["order", "ASC"]
	["age"]
).limit(1).offset(10)

console.log JSON.stringify(q._properties, null, 4)