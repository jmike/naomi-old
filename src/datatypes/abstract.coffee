###
@author Dimitrios C. Michalakos
###
class AbstractDatatype

	###
	Constructs a new abstract datatype.
	@param {Object} properties key/value properties (optional).
    @option options {Boolean} nullable
	@throw {Error} if properties is of the wrong type.
	###
	constructor: (properties = {}) ->
		if typeof properties isnt "object"
			throw new Error("Invalid datatype properties: expected Object, got #{typeof properties}")
		@properties = properties

	###
	@overload nullable()
	  Indicates whether an explicit null value can be assigned to the datatype.
	  @return {Boolean}
	@overload nullable(value)
	  Specifies whether an explicit null value can be assigned to the datatype.
	  @param {Boolean} nullable
	  @return {AbstractDatatype} to allow method chaining.
	###
	nullable: (nullable) ->
		switch typeof nullable
			when "undefined"
				return @properties.nullable is true
			when "boolean"
				@properties.nullable = nullable
				return this
			else
				throw new Error("Invalid nullable value: expected Boolean, got #{typeof nullable}")

	###
	Throws an error if the specified value cannot be assigned to the datatype.
	@param {*} value
	@throw {Error} if value is invalid.
	###
	validate: (value) ->
		if value is null and @properties.nullable isnt true
			throw new Error("Datatype cannot be assigned to a null value")

module.exports = AbstractDatatype