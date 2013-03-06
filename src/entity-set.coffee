esprima = require("esprima")

###
@author Dimitrios C. Michalakos
###
class EntitySet

	###*
	* Constructs a new entity set of the specified properties.
	* @param {Object} connector the database connector.
	* @param {String} name the name of the entity set.
	* @param {Object} attributes the attributes of the entity set.
	* @param {Object} options key/value properties (optional).
	###
	constructor: (connector, name, attributes, options = {}) ->
		if typeof connector isnt "object"
			throw new Error("Invalid connector: expected object, got #{typeof connector}")
		if typeof name isnt "string"
			throw new Error("Invalid name: expected string, got #{typeof name}")
		if name.length is 0
			throw new Error("Invalid name: cannot be empty")
		if typeof attributes isnt "object"
			throw new Error("Invalid attributes: expected object, got #{typeof attributes}")
		if typeof options isnt "object"
			throw new Error("Invalid options: expected object, got #{typeof options}")

		@_connector = connector
		@name = name
		@attributes = attributes
		@options = options
		@query = {}

	###
	@overload filter()
	  Returns the abstract syntax tree of the filter function.
	  @return {Object, undefined}
	@overload filter(value)
	  Filters the entity set with the test implemented by the provided function.
	  @param {Function, String} callback the function to test each entity of the entity set.
	  @return {EntitySet} to allow method chaining.
	  @throw {Error} if value is invalid.
	@example Filter using a function.
	  filter(function(entity) {return entity.id >= 10})
	@example Filter using a string expression.
	  filter("entity.id === 42")
	###
	filter: (callback) ->
		switch typeof callback
			when "undefined"
				return @query.filter
			when "string"
				try
					@query.filter = esprima.parse(callback)
				catch error
					throw new Error("Filter parse error: #{error.message}")
			when "function"
				try
					@query.filter = esprima.parse(callback.toString())# function.toString()
				catch error
					throw new Error("Filter parse error: #{error.message}")
			else
				throw new Error("Invalid filter: expected function or string, got #{typeof callback}")
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
	
	###
	Fetches entities from the remote database.
	@param {Object} options key/value settings (optional).
	@param {Function} callback i.e. function(error, entities).
	@return {EntitySet} to allow method chaining.
	###
	fetch: (options, callback = -> null) ->
		if typeof options is "function"
			callback = options
			options = {}
		
		@_connector.fetch(@name, @attributes, @query, options, callback)
		return this
		
	count: -> null
	
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

	update: -> null
	
	destroy: -> null

module.exports = EntitySet