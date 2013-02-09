AbstractDatatype = require("./abstract")
NumberUtils = require("../utils/number")

###
@extend AbstractDatatype
@author Dimitrios C. Michalakos
###
class StringDatatype extends AbstractDatatype

	###
	Constructs a new string datatype.
	@param {Object} options key/value properties (optional).
	###
	constructor: (options = {}) ->
		super(options)

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
				return @options.minLength
			when "number"
				if NumberUtils.isNonNegativeInt(value)
					@options.minLength = value
					return this
				else
					throw new Error("Invalid minimum length - cannot be negative")
			else
				throw new Error("Invalid minimum length - expected Number, got #{typeof value}")
		
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
				return @options.maxLength
			when "number"
				if NumberUtils.isPositiveInt(value)
					@options.maxLength = value
					return this
				else
					throw new Error("Invalid maximum length - cannot be negative or zero")
			else
				throw new Error("Invalid maximum length - expected Number, got #{typeof value}")
		
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
				return @options.length
			when "number"
				if NumberUtils.isPositiveInt(value)
					@options.length = value
					return this
				else
					throw new Error("Invalid length - cannot be negative or zero")
			else
				throw new Error("Invalid length - expected Number, got #{typeof value}")
		
	###
	Sets the datatype's allowed value(s).
	@param {String} values an infinite number of values separated by comma.
	@return {StringDatatype} to allow method chaining.
	###
	equals: (values...) ->
		if values.length is 0
			throw new Error("You must specify at least one allowed value")
		for e in values when typeof e isnt "string"
			throw new Error("Invalid allowed value - expected string, got #{typeof e}")
		@options.equals = values
		return this

	###
	Sets the datatype's prohibited value(s).
	@param {String} values an infinite number of values separated by comma.
	@return {StringDatatype} to allow method chaining.
	###
	notEquals: (values...) ->
		if values.length is 0
			throw new Error("You must specify at least one prohibited value")
		for e in values when typeof e isnt "string"
			throw new Error("Invalid prohibited value - expected string, got #{typeof e}")
		@options.notEquals = values
		return this

	###
	Sets a regex to match the datatype's value.
	@param {RegExp} re
	@return {StringDatatype} to allow method chaining.
	###
	regex: (re) ->
		unless re instanceof RegExp
			throw new Error("Invalid regular expression - expected RegExp, got #{typeof re}")
		@options.regex = re
		return this

	###
	Sets a regex to not match the datatype's value.
	@param {RegExp} re
	@return {StringDatatype} to allow method chaining.
	###
	notRegex: (re) ->
		unless re instanceof RegExp
			throw new Error("Invalid regular expression - expected RegExp, got #{typeof re}")
		@options.notRegex = re
		return this

	###
	Sets a string to contain in the datatype's value.
	@param {String} str
	@return {StringDatatype} to allow method chaining.
	###
	contains: (str) ->
		if typeof str isnt "string"
			throw new Error("Invalid string - expected String, got #{typeof str}")
		if str.length is 0
			throw new Error("String cannot be empty")
		@options.contains = str
		return this
		
	###
	Sets a string to not contain in the datatype's value.
	@param {String} str
	@return {StringDatatype} to allow method chaining.
	###
	notContains: (str) ->
		if typeof str isnt "string"
			throw new Error("Invalid string - expected String, got #{typeof str}")
		if str.length is 0
			throw new Error("String cannot be empty")
		@options.notContains = str
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
			if @options.minLength? and value.length < @options.minLength
				throw new Error("Datatype must have at least #{@options.minLength} characters in length")

			if @options.maxLength? and value.length > @options.maxLength
				throw new Error("Datatype must have at most #{@options.maxLength} characters in length")

			if @options.length? and value.length isnt @options.length
				throw new Error("Datatype must have exactly #{@options.length} characters in length")

			if @options.equals? and value not in @options.equals
				throw new Error("Datatype must be equal to an allowed value")

			if @options.notEquals? and value in @options.notEquals
				throw new Error("Datatype cannot be equal to a prohibited value")

			if @options.regex? and not @options.regex.test(value)
				throw new Error("Datatype must match the regular expression #{@options.regex.toString()}")

			if @options.notRegex? and @options.notRegex.test(value)
				throw new Error("Datatype cannot match the regular expression #{@options.notRegex.toString()}")

			if @options.contains? and value.indexOf(@options.contains) is -1
				throw new Error("Datatype must contain the value #{@options.contains}")

			if @options.notContains? and value.indexOf(@options.notContains) isnt -1
				throw new Error("Datatype cannot contain the value #{@options.notContains}")

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