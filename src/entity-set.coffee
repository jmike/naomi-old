esprima = require("esprima")

###
@author Dimitrios C. Michalakos
###
class EntitySet

	###*
	* Constructs a new entity set of the specified properties.
	* @param {String} name the entity set's name.
	* @param {Object} attributes the entity set's attributes (optional).
	* @param {Object} options key/value properties (optional).
	###
	constructor: (name, attributes = {}, options = {}) ->
		if typeof name isnt "string"
			throw new Error("Invalid name: expected string, got #{typeof name}")
		if name.length is 0
			throw new Error("Invalid name: cannot be empty")
		if typeof attributes isnt "object"
			throw new Error("Invalid attributes: expected object, got #{typeof attributes}")
		if typeof options isnt "object"
			throw new Error("Invalid options: expected object, got #{typeof options}")
		@name = name
		@attributes = attributes
		@options = options
		@query = {}
		return

	###
	@overload filter()
	  Returns the the maximum number of digits allowed in the datatype's value.
	  @return {Object}
	@overload filter(value)
	  Applies the designated filter to the entity set.
	  @param {String, Function} value a javascript expression.
	  @return {EntitySet} to allow method chaining.
	  @throw {Error} if value is invalid.
	@example Filter using a function.
	  filter(function(entity) {entity.id >= 10})
	@example Filter using a string expression.
	  filter("entity.id === 42")
	###
	filter: (value) ->
		switch typeof value
			when "undefined"
				return @query.filter
			when "string"
				try
					filter = esprima.parse(value)
				catch error
					throw error
			when "function"
				try
					filter = esprima.parse(value.toString())# function.toString()
				catch error
					throw error
			else
				throw new Error("Invalid filter value: expected function or string, got #{typeof value}")
		@query.filter = filter
		return this

	###
	Validates the supplied data against the entity set's attributes.
	@param {Object} data key/value properties, where key is the name of the entity set's attribute.
	@throw {Error} if data are invalid.
	###
	validate: (data) ->		
		for own k, attr of @attributes
			try
				attr.validate(data[k])
			catch error
				throw error
		return
	
	fetch: -> null
	count: -> null
	destroy: -> null
	update: -> null
	
	###
	Adds a new entity or an array of entities to the entity set.
	@param {Object, Array<Object>} data
	@param {Boolean} updateDuplicate a boolean flag indicating whether duplicate entities should be updated (optional).
	@param {Function} callback i.e. function(error, summary).
	###
	add: (data, updateDuplicate = false, callback = -> null) ->
		# Make sure input parameters are valid
		if typeof data isnt "object"
			throw new Error("Invalid data to add - expected Object, got #{typeof data}")
		if typeof updateDuplicate is "function"
			callback = updateDuplicate
		else if typeof updateDuplicate isnt "boolean"
			throw new Error("Invalid updateDuplicate flag - expected Boolean, got #{typeof updateDuplicate}")
		if typeof callback isnt "function"
			throw new Error("Invalid callback - expected Functions, got #{typeof callback}")
		
		# Make sure supplied data are valid
		try
			if Array.isArray(data)
				for entity in data
					this.validate(entity)
			else
				this.validate(data)
		catch error
			callback(error)
			return

module.exports = EntitySet