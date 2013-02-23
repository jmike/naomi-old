###
@author Dimitrios C. Michalakos
###
class AbstractDatatype

	###
	Constructs a new abstract datatype.
	@param {Object} properties key/value properties (optional).
	@throw {Error} if properties is of the wrong type.
	###
	constructor: (properties = {}) ->
		if typeof properties isnt "object"
			throw new Error("Invalid datatype's properties: expected Object, got #{typeof properties}")
		@properties = properties

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
				return @properties.nullable
			when "boolean"
				@properties.nullable = value
				return this
			else
				throw new Error("Invalid nullable value: expected Boolean, got #{typeof value}")

	###
	Throws an error if the specified value is invalid.
	@param {*} value
	@throw {Error} if value is invalid.
	###
	validate: (value) ->
		if value is null and not @properties.nullable
			throw new Error("Datatype cannot be assigned with a null value")
		return

module.exports = AbstractDatatype