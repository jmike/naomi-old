###
@author Dimitrios C. Michalakos
###
class AbstractAttribute

	###
	Constructs a new generic attribute.
	@param {Object} options key/value properties (optional).
	@throw {Error} if options is of the wrong type.
	###
	constructor: (options = {}) ->
		if typeof options isnt "object"
			throw new Error("Invalid attribute's options - expected Object, got #{typeof options}")
		@options = options

	###
	Specifies whether an explicit null value can be assigned to the attribute.
	@param {Boolean} bool (optional).
	@return {AbstractAttribute} to allow method chaining.
	###
	nullable: (bool = true) ->
		if typeof bool isnt "boolean"
			throw new Error("Invalid nullable value - expected Boolean, got #{typeof value}")
		@options.nullable = bool
		return this
	
	###
	Parses the supplied value to match the attribute's internal type.
	@param {*} value
	@return {*}
	###	
	@parse: (value) -> value

	###
	Throws an error if the specified value is invalid.
	@param {*} value
	@throw {Error} if value is invalid.
	###
	validate: (value) ->
		if value is null and not @options.nullable
			throw new Error("Cannot be assigned with a null value")
		return

module.exports = AbstractAttribute