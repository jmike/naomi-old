AbstractDatatype = require("./abstract")
NumberUtils = require("../utils/number")

###
@extend AbstractDatatype
@author Dimitrios C. Michalakos
###
class StringDatatype extends AbstractDatatype

	###
	Constructs a new string datatype.
	@param {Object} properties key/value properties (optional).
	###
	constructor: (properties = {}) ->
		super(properties)

	###
	@overload minLength()
	  Returns the datatype's minimum length.
	  @return {Number}
	@overload minLength(value)
	  Sets the datatype's minimum length.
	  @param {Number} value number of characters.
	  @return {StringDatatype} to allow method chaining.
	###
	minLength: (value) ->
		switch typeof value
			when "undefined"
				if @properties.minLength?
					return @properties.minLength
				else if @properties.equals?
					return Math.min.apply(Math, @properties.equals.map((e) -> e.length))
				else
					return undefined
			when "number"
				unless NumberUtils.isNonNegativeInt(value)
					throw new Error("Invalid minimum length: cannot be negative")
				if value > @properties.maxLength
					throw new Error("Invalid minimum length: cannot be greater than maximum length")
				@properties.minLength = value
				return this	
			else
				throw new Error("Invalid minimum length: expected number, got #{typeof value}")
		
	###
	@overload maxLength()
	  Returns the datatype's maximum length.
	  @return {Number}
	@overload maxLength(value)
	  Sets the datatype's maximum length.
	  @param {Number} length number of characters.
	  @return {StringDatatype} to allow method chaining.
	###
	maxLength: (value) ->
		switch typeof value
			when "undefined"
				if @properties.maxLength?
					return @properties.maxLength
				else if @properties.equals?
					return Math.max.apply(Math, @properties.equals.map((e) -> e.length));
				else
					return undefined
			when "number"
				unless NumberUtils.isPositiveInt(value)
					throw new Error("Invalid maximum length: cannot be negative or zero")
				if value < @properties.minLength
					throw new Error("Invalid maximum length: cannot be less than minimum length")
				@properties.maxLength = value
				return this	
			else
				throw new Error("Invalid maximum length: expected number, got #{typeof value}")
		
	###
	@overload length()
	  Returns the datatype's exact length.
	  @return {Number}
	@overload length(value)
	  Sets the datatype's exact length.
	  @param {Number} length number of characters.
	  @return {StringDatatype} to allow method chaining.
	###
	length: (value) ->
		switch typeof value
			when "undefined"
				return @properties.length
			when "number"
				unless NumberUtils.isPositiveInt(value)
					throw new Error("Invalid exact length: cannot be negative or zero")
				@properties.length = value
				return this
			else
				throw new Error("Invalid exact length: expected number, got #{typeof value}")
		
	###
	@overload equals()
	  Returns the datatype's allowed values.
	  @return {Array.<String>}
	@overload equals(values...)
	  Sets the datatype's allowed values.
	  @param {String} values an infinite number of values separated by comma.
	  @return {StringDatatype} to allow method chaining.
	###
	equals: (values...) ->
		if values.length is 0
			return @properties.equals
		else
			for e in values when typeof e isnt "string"
				throw new Error("Invalid allowed value: expected string, got #{typeof e}")
			@properties.equals = values
			return this

	###
	@overload notEquals()
	  Returns the datatype's prohibited values.
	  @return {Array.<String>}
	@overload notEquals(values...)
	  Sets the datatype's prohibited values.
	  @param {String} values an infinite number of values separated by comma.
	  @return {StringDatatype} to allow method chaining.
	###
	notEquals: (values...) ->
		if values.length is 0
			return @properties.notEquals
		else
			for e in values when typeof e isnt "string"
				throw new Error("Invalid prohibited value: expected string, got #{typeof e}")
			@properties.notEquals = values
			return this

	###
	Sets a regex to match the datatype's value.
	@param {RegExp} re
	@return {StringDatatype} to allow method chaining.
	###
	regex: (re) ->
		unless re instanceof RegExp
			throw new Error("Invalid regular expression: expected RegExp, got #{typeof re}")
		@properties.regex = re
		return this

	###
	Sets a regex to not match the datatype's value.
	@param {RegExp} re
	@return {StringDatatype} to allow method chaining.
	###
	notRegex: (re) ->
		unless re instanceof RegExp
			throw new Error("Invalid regular expression: expected RegExp, got #{typeof re}")
		@properties.notRegex = re
		return this

	###
	Sets a string to contain in the datatype's value.
	@param {String} str
	@return {StringDatatype} to allow method chaining.
	###
	contains: (str) ->
		if typeof str isnt "string"
			throw new Error("Invalid string to contain: expected string, got #{typeof str}")
		if str.length is 0
			throw new Error("String cannot be empty")
		@properties.contains = str
		return this
		
	###
	Sets a string to not contain in the datatype's value.
	@param {String} str
	@return {StringDatatype} to allow method chaining.
	###
	notContains: (str) ->
		if typeof str isnt "string"
			throw new Error("Invalid string to not contain: expected string, got #{typeof str}")
		if str.length is 0
			throw new Error("Invalid string to not contain: value cannot be empty")
		@properties.notContains = str
		return this

	###
	Parses the supplied value and returns string or null.
	@param {*} value
	@return {String, null}
	###
	@parse: (value) ->
		if value?
			return value.toString()
		else# null, undefined
			return null

	###
	Throws an error if the specified value is invalid.
	@param {*} value
	@param {Boolean} parse indicates whether the specified value should be parsed, defaults to true.
	@throw {Error} if value is invalid.
	###
	validate: (value, parse = true)  ->
		if parse
			value = StringDatatype.parse(value)
		
		if value?
			if @properties.minLength? and value.length < @properties.minLength
				throw new Error("Datatype must have at least #{@properties.minLength} characters in length")

			if @properties.maxLength? and value.length > @properties.maxLength
				throw new Error("Datatype must have at most #{@properties.maxLength} characters in length")

			if @properties.length? and value.length isnt @properties.length
				throw new Error("Datatype must have exactly #{@properties.length} characters in length")

			if @properties.equals? and value not in @properties.equals
				throw new Error("Datatype must be equal to an allowed value")

			if @properties.notEquals? and value in @properties.notEquals
				throw new Error("Datatype cannot be equal to a prohibited value")

			if @properties.regex? and not @properties.regex.test(value)
				throw new Error("Datatype must match the regular expression #{@properties.regex.toString()}")

			if @properties.notRegex? and @properties.notRegex.test(value)
				throw new Error("Datatype cannot match the regular expression #{@properties.notRegex.toString()}")

			if @properties.contains? and value.indexOf(@properties.contains) is -1
				throw new Error("Datatype must contain the value #{@properties.contains}")

			if @properties.notContains? and value.indexOf(@properties.notContains) isnt -1
				throw new Error("Datatype cannot contain the value #{@properties.notContains}")

		super(value)	
		return

	###
	Parses the supplied value and returns string or null.
	@param {*} value
	@param {Boolean} validate indicates whether the value should be validated, defaults to true.
	@return {Boolean, null}
	###	
	parse: (value, validate = true) ->
		value = StringDatatype.parse(value)
		if validate
			try
				this.validate(value, false)
			catch error
				throw error
		return value

module.exports = StringDatatype