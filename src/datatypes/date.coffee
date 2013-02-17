AbstractDatatype = require("./abstract")
moment = require("moment")

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
	  @param {Date, String} value
	  @return {DateDatatype} to allow method chaining.
	###
	min: (value) ->
		switch typeof value
			when "undefined"
				return @_properties.min
			when "string"
				x = moment(value, "YYYY-MM-DD")
				unless x.isValid()
					throw new Error("Invalid minimum value: cannot be parsed as date")
				@_properties.min = x.toDate()
			else
				if value not instanceof Date
					throw new Error("Invalid minimum value: expected Date, got #{typeof value}")
				@_properties.min = value
		return this
		
	###
	@overload max()
	  Returns the datatype's maximum allowed value.
	  @return {Date}
	@overload max(value)
	  Sets the datatype's maximum allowed value.
	  @param {Date, String} value
	  @return {DateDatatype} to allow method chaining.
	###
	max: (value) ->
		switch typeof value
			when "undefined"
				return @_properties.max
			when "string"
				x = moment(value, "YYYY-MM-DD")
				unless x.isValid()
					throw new Error("Invalid maximum value: cannot be parsed as date")
				@_properties.max = x.toDate()
			else
				if value not instanceof Date
					throw new Error("Invalid maximum value: expected Date, got #{typeof value}")
				@_properties.max = value
		return this
		
	###
	@overload equals()
	  Returns the datatype's allowed values.
	  @return {Array.<Date>}
	@overload equals(values...)
	  Sets the datatype's allowed values.
	  @param {Date} values an infinite number of values separated by comma.
	  @return {DateDatatype} to allow method chaining.
	###
	equals: (values...) ->
		if values.length is 0
			return @_properties.equals
		else
			for value, i in values
				if typeof value is "string"
					x = moment(value, "YYYY-MM-DD")
					unless x.isValid()
						throw new Error("Invalid allowed value: cannot be parsed as date")
					values[i] = x.toDate()
				else if value not instanceof Date
					throw new Error("Invalid allowed value: expected date, got #{typeof e}")
			@_properties.equals = values
			return this

	###
	@overload notEquals()
	  Returns the datatype's prohibited values.
	  @return {Array.<Date>}
	@overload notEquals(values...)
	  Sets the datatype's prohibited values.
	  @param {Date} values an infinite number of values separated by comma.
	  @return {DateDatatype} to allow method chaining.
	###
	notEquals: (values...) ->
		if values.length is 0
			return @_properties.notEquals
		else
			for value, i in values
				if typeof value is "string"
					x = moment(value, "YYYY-MM-DD")
					unless x.isValid()
						throw new Error("Invalid prohibited value: cannot be parsed as date")
					values[i] = x.toDate()
				else if value not instanceof Date
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
				x = moment(value, "YYYY-MM-DD")
				return x.toDate()
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