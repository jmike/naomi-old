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

module.exports = GenericAttribute