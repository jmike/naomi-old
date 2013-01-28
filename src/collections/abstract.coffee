###
@author Dimitrios C. Michalakos
###
class AbstractCollection

	###*
	* Constructs a new generic collection of the specified properties.
	* @param {String} name the collection's name.
	* @param {Object} attributes the collection's attributes (optional).
	* @param {Object} options key/value properties (optional).
	###
	constructor: (name, attributes = {}, options = {}) ->
		if typeof name isnt "string"
			throw new Error("Invalid collection name - expected String, got #{typeof name}")
		if name.length is 0
			throw new Error("Invalid collection name - cannot be empty")
		if typeof attributes isnt "object"
			throw new Error("Invalid collection attributes - expected Object, got #{typeof attributes}")
		if typeof options isnt "object"
			throw new Error("Invalid collection options - expected Object, got #{typeof options}")
		@name = name
		@attributes = attributes
		@options = options
		return
	
	###
	Validates the supplied data against the collection's attributes.
	@param {Object} data
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
	Adds a new model or an array of models to the collection.
	@param {Object, Array<Object>} data
	@param {Boolean} updateDuplicate a boolean flag indicating whether duplicate models should be updated (optional).
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
				for model in data
					this.validate(model)
			else
				this.validate(data)
		catch error
			callback(error)
			return

		
	
module.exports = AbstractCollection

#User = Naomi.extend("user", {
#	"name": new StringAttribute.maxLength(100)
#	"email": new EmailAttribute.nullable().maxLength(150)
#}, {
#	engine: Naomi.MYISAM
#})
#User.fetch(Query.filter(["id", "=", 10]).order("name").offset(5).limit(1), callback)
#User.fetch().where(["id", "=", 10]).order("name").offset(5).limit(1).execute(callback)
