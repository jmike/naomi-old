AbstractDatatype = require("./abstract")

###
@extend AbstractDatatype
@author Dimitrios C. Michalakos
###
class DateDatatype extends AbstractDatatype

	###
	Constructs a new date datatype.
	@param {Object} properties key/value properties (optional).
	###
	constructor: (properties = {}) ->
		super(properties)

	###
	@overload min()
	  Returns the datatype's minimum allowed value.
	  @return {Date}
	@overload min(value)
	  Sets the datatype's minimum allowed value.
	  @param {Date} value
	  @return {DateDatatype} to allow method chaining.
	###
	min: (value) ->
		if typeof value is "undefined"
			return @_properties.min
		else if value instanceof Date
			@_properties.min = value
			return this
		else
			throw new Error("Invalid value: expected Date, got #{typeof value}")
		
	###
	@overload max()
	  Returns the datatype's maximum allowed value.
	  @return {Date}
	@overload max(value)
	  Sets the datatype's maximum allowed value.
	  @param {Date} value
	  @return {DateDatatype} to allow method chaining.
	###
	max: (value) ->
		if typeof value is "undefined"
			return @_properties.max
		else if value instanceof Date
			@_properties.max = value
			return this
		else
			throw new Error("Invalid value: expected Date, got #{typeof value}")
		
	###
	Sets the datatype's allowed value(s).
	@param {Date} values an infinite number of values separated by comma.
	@return {DateDatatype} to allow method chaining.
	###
	equals: (values...) ->
		if values.length is 0
			throw new Error("You must specify at least one allowed value")
		for e in values when not e instanceof Date
			throw new Error("Invalid allowed value: expected date, got #{typeof e}")
		@_properties.equals = values
		return this

	###
	Sets the datatype's prohibited value(s).
	@param {Date} values an infinite number of values separated by comma.
	@return {DateDatatype} to allow method chaining.
	###
	notEquals: (values...) ->
		if values.length is 0
			throw new Error("You must specify at least one prohibited value")
		for e in values when not e instanceof Date
			throw new Error("Invalid prohibited value: expected date, got #{typeof e}")
		@_properties.notEquals = values
		return this

	###
	Parses the supplied value and returns Date or null.
	@param {*} value
	@return {Date, null}
	###
	@parse: (value) ->
		if value?
			if value instanceof Date
				return value
			else
				return new Date(value)
		else
			return null

	###
	Throws an error if the specified value is invalid.
	@param {*} value
	@param {Boolean} parse indicates whether the specified value should be parsed, defaults to true.
	@throw {Error} if value is invalid.
	###
	validate: (value, parse = true) ->
		if parse
			value = DateDatatype.parse(value)

		if value?
			if @_properties.min? and value < @_properties.min
				throw new Error("Datatype must be at least #{@_properties.min} in value")

			if @_properties.max? and value > @_properties.max
				throw new Error("Datatype must be at most #{@_properties.max} in value")

			if @_properties.equals? and value not in @_properties.equals
				throw new Error("Datatype should match an allowed value")

			if @_properties.notEquals? and value in @_properties.notEquals
				throw new Error("Datatype cannot match a prohibited value")
								
		super(value)
		return
		
	###
	Parses the supplied value and returns Date or null.
	@param {*} value
	@param {Boolean} validate indicates whether the value should be validated, defaults to true.
	@return {Date, null}
	###
	parse: (value, validate = true) ->
		value = DateDatatype.parse(value)
		if validate
			try
				this.validate(value, false)
			catch error
				throw error
		return value

module.exports = DateDatatype