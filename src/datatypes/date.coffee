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
				return @properties.min
			when "string"
				x = moment(value, @properties.format)
				unless x.isValid()
					throw new Error("Invalid minimum value: cannot be parsed as date")
				@properties.min = x.toDate()
			else
				if value not instanceof Date
					throw new Error("Invalid minimum value: expected Date, got #{typeof value}")
				@properties.min = value
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
				return @properties.max
			when "string"
				x = moment(value, @properties.format)
				unless x.isValid()
					throw new Error("Invalid maximum value: cannot be parsed as date")
				@properties.max = x.toDate()
			else
				if value not instanceof Date
					throw new Error("Invalid maximum value: expected Date, got #{typeof value}")
				@properties.max = value
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
			return @properties.equals
		else
			for value, i in values
				if typeof value is "string"
					x = moment(value, @properties.format)
					unless x.isValid()
						throw new Error("Invalid allowed value: cannot be parsed as date")
					values[i] = x.toDate()
				else if value not instanceof Date
					throw new Error("Invalid allowed value: expected date, got #{typeof e}")
			@properties.equals = values
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
			return @properties.notEquals
		else
			for value, i in values
				if typeof value is "string"
					x = moment(value, @properties.format)
					unless x.isValid()
						throw new Error("Invalid prohibited value: cannot be parsed as date")
					values[i] = x.toDate()
				else if value not instanceof Date
					throw new Error("Invalid prohibited value: expected date, got #{typeof e}")
			@properties.notEquals = values
			return this

	###
	@overload format()
	  Returns the date format used to parse the datatype's value.
	  @return {String}
	@overload format(value)
	  Sets the date format to parse the datatype's value.
	  @param {String} format a valid date format, e.g. "YYYY-MM-DD".
	  @return {DateDatatype} to allow method chaining.
	###
	format: (value) ->
		switch typeof value
			when "undefined"
				return @properties.format
			when "string"
				@properties.format = value
				return this
			else
				throw new Error("Invalid date format: expected string, got #{typeof value}")

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
				x = moment(value)
				return x.toDate()
		else
			return null

	###
	Throws an error if the specified value is invalid.
	@param {*} value
	@param {Boolean} parse indicates whether the specified value should be parsed, defaults to true.
	@note Turn parse to false only if you know what you are doing.
	@throw {Error} if value is invalid.
	###
	validate: (value, parse = true) ->
		if parse
			value = DateDatatype.parse(value)

		if value?
			format = @properties.format
			if @properties.min? and value.getTime() < @properties.min.getTime()
				throw new Error("Datatype must be at least #{@properties.min} in value")

			if @properties.max? and value.getTime() > @properties.max.getTime()
				throw new Error("Datatype must be at most #{@properties.max} in value")

			if @properties.equals? and value.getTime() not in @properties.equals.map((e) -> e.getTime())
				throw new Error("Datatype should match an allowed value")

			if @properties.notEquals? and value.getTime() in @properties.notEquals.map((e) -> e.getTime())
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