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
	@overload nullable()
	  Indicates whether an explicit null value can be assigned to the datatype.
	  @return {Boolean}
	@overload nullable(value)
	  Specifies whether an explicit null value can be assigned to the datatype.
	  @param {Boolean} x (optional).
	  @return {AbstractDatatype} to allow method chaining.
	###
	nullable: (value) ->
		switch typeof value
			when "undefined"
				return @options.nullable
			when "boolean"
				@options.nullable = value
				return this
			else
				throw new Error("Invalid nullable value - expected Boolean, got #{typeof value}")

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