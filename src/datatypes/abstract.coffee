###
@author Dimitrios C. Michalakos
###
class AbstractDatatype

	###
	Constructs a new abstract datatype.
	@param {Object} options key/value properties (optional).
	@throw {Error} if options is of the wrong type.
	###
	constructor: (options = {}) ->
		if typeof options isnt "object"
			throw new Error("Invalid datatype's options - expected Object, got #{typeof options}")
		@options = options

	###
	Specifies whether an explicit null value can be assigned to the datatype.
	@param {Boolean} x (optional).
	@return {AbstractDatatype} to allow method chaining.
	###
	nullable: (x = true) ->
		if typeof x isnt "boolean"
			throw new Error("Invalid nullable value - expected Boolean, got #{typeof x}")
		@options.nullable = x
		return this

	###
	Throws an error if the specified value is invalid.
	@param {*} value
	@throw {Error} if value is invalid.
	###
	validate: (value) ->
		if value is null and not @options.nullable
			throw new Error("Datatype cannot be assigned with a null value")
		return

module.exports = AbstractDatatype