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
    @option options {Boolean} nullable
    @option options {Date, String} min
    @option options {Date, String} max
    @option options {Array.<Date>} equals
    @option options {Array.<Date>} notEquals
    @option options {String} format
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
      @throw {Error} if the supplied value is invalid.
	###
	min: (value) ->
		switch typeof value
			when "undefined"
				return @properties.min

			when "string"
				d = moment(value, @properties.format)
				if d.isValid()
					@properties.min = d.toDate()
				else
					throw new Error("Invalid minimum value: cannot be parsed as date")

			else# possibly date
				if value instanceof Date
					@properties.min = value
				else
					throw new Error("Invalid minimum value: expected date or string, got #{typeof value}")

		return this
		
	###
	@overload max()
	  Returns the datatype's maximum allowed value.
	  @return {Date}
	@overload max(value)
	  Sets the datatype's maximum allowed value.
	  @param {Date, String} value
	  @return {DateDatatype} to allow method chaining.
      @throw {Error} if the supplied value is invalid.
	###
	max: (value) ->
		switch typeof value
			when "undefined"
				return @properties.max

			when "string"
				d = moment(value, @properties.format)
				if d.isValid()
					@properties.max = d.toDate()
				else
					throw new Error("Invalid maximum value: cannot be parsed as date")

			else# possibly date
				if value instanceof Date
					@properties.max = value
				else
					throw new Error("Invalid maximum value: expected date or string, got #{typeof value}")

		return this
		
	###
	@overload equals()
	  Returns an array of datatype allowed values.
	  @return {Array.<Date>}
	@overload equals(values...)
	  Sets the datatype's allowed values.
	  @param {Date} values an infinite number of values separated by comma.
	  @return {DateDatatype} to allow method chaining.
      @throw {Error} if the supplied values are invalid.
	###
	equals: (values...) ->
		if values.length is 0
			return @properties.equals

		else
			equals = []
			for value, i in values
				if typeof value is "string"
					d = moment(value, @properties.format)
					if d.isValid()
						equals[i] = d.toDate()
					else
						throw new Error("Invalid allowed value: cannot be parsed as date")

				else# possibly date
					if value instanceof Date
						equals[i] = value
					else
						throw new Error("Invalid allowed value: expected date or string, got #{typeof value}")

			@properties.equals = equals
			return this

	###
	@overload notEquals()
	  Returns an array of datatype prohibited values.
	  @return {Array.<Date>}
	@overload notEquals(values...)
	  Sets the datatype's prohibited values.
	  @param {Date} values an infinite number of values separated by comma.
	  @return {DateDatatype} to allow method chaining.
      @throw {Error} if the supplied values are invalid.
	###
	notEquals: (values...) ->
		if values.length is 0
			return @properties.notEquals

		else
			notEquals = []
			for value, i in values
				if typeof value is "string"
					d = moment(value, @properties.format)
					if d.isValid()
						notEquals[i] = d.toDate()
					else
						throw new Error("Invalid prohibited value: cannot be parsed as date")

				else# possibly date
					if value instanceof Date
						notEquals[i] = value
					else
						throw new Error("Invalid prohibited value: expected date or string, got #{typeof value}")

			@properties.notEquals = notEquals
			return this

	###
	@overload format()
	  Returns the date format used to parse the datatype's value.
	  @return {String}
	@overload format(value)
	  Sets the date format to parse the datatype's value.
	  @param {String} format a valid date format, e.g. "YYYY-MM-DD".
	  @return {DateDatatype} to allow method chaining.
      @throw {Error} if the supplied value is invalid.
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
				d = moment(value)
				return d.toDate()
		else
			return null

	###
	Throws an error if the specified value cannot be assigned to the datatype.
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
	@return {Date, null}
    @throw {Error} if value is invalid.
	###
	parse: (value) ->
		value = DateDatatype.parse(value)

		try
			this.validate(value, false)
		catch error
			throw error

		return value

module.exports = DateDatatype