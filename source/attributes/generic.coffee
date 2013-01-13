###
GenericAttribute represents a generic attribute of an entity.
@author Dimitrios C. Michalakos
###
class GenericAttribute

	###
	Constructs a new generic attribute of the designated name and constraints.
	@param {String} name the attribute's name.
	@param {Object} options key/value constraints (optional).
	###
	constructor: (name, options = {}) ->
		if typeof name isnt "string"
			throw new Error("Invalid attribute's name - expected String, got #{typeof name}")
		if name.length is 0
			throw new Error("Attribute's name cannot be empty")
		if typeof options isnt "object"
			throw new Error("Invalid attribute's options - expected Object, got #{typeof name}")
		@name = name
		@options = options

	###
	Specifies whether an explicit null value can be assigned to the attribute.
	@param {Boolean} bool (optional), true by default.
	@return {GenericAttribute} to allow method chaining.
	###
	nullable: (bool = true) ->
		if typeof bool isnt "boolean"
			throw new Error("Invalid nullable value - expected Boolean, got #{typeof value}")
		@options.nullable = bool
		return this
	
	###
	Parses the supplied value and returns a new value the conforms to the attribute's type.
	@param {*} value
	@return {*}
	###	
	parse: (value) -> value

	###
	Throws an error if the specified value is invalid.
	@param {*} value
	@throw {Error} if value is invalid.
	###	
	validate: (value) ->
		value = this.parse(value)
		if value is null and not @options.nullable
			throw new Error("Attribute #{@name} cannot be assigned with a null value")
		return

module.exports = GenericAttribute