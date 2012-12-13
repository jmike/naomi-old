###
GenericAttribute represents the generic attribute of an entity.
@author Dimitrios C. Michalakos
###
class GenericAttribute

	###
	Constructs a new attribute of the designated name and constraints.
	@param {String} name the attribute's name.
	@param {Object} options key/value constraints (optional).
	###
	constructor: (name, options = {}) ->
		if typeof name isnt "string"
			throw new Error("Invalid attribute's name - expected String, got #{typeof name}")
		if name.length is 0
			throw new Error("Attribute's name cannot be empty")
		@name = name
		@options = options

	###
	Specifies whether an explicit null value can be assigned to the attribute.
	@param {Boolean} bool
	@return {GenericAttribute} to allow method chaining.
	###
	nillable: (bool = true) ->
		if typeof bool isnt "boolean"
			throw new Error("Invalid nillable value - expected Boolean, got #{typeof value}")
		@options.nillable = bool
		return this

module.exports = GenericAttribute