GenericAttribute = require("./generic")
NumberUtils = require("../utils/number")

###
StringAttribute represents a string attribute.
###
class StringAttribute extends GenericAttribute

	###
	Constructs a new StringAttribute instance of the designated name.
	@param {String} name the attribute's name.
	@param {Object} options key/value constraints (optional).
	###
	constructor: (name, options = {}) ->
		super(name, options)

	###
	Sets the attribute's minimum length.
	@param {Number} len number of characters.
	@return {StringAttribute} to allow method chaining.
	###
	minLength: (len) ->
		if typeof len isnt "number"
			throw new Error("Invalid length - expected Number, got #{typeof len}")
		unless NumberUtils.isNonNegativeInt(len)
			throw new Error("Minimum length must be a integer at least 0 in value")
		@options.minLength = len
		return this
		
	###
	Sets the attribute's maximum length.
	@param {Number} length number of characters.
	@return {StringAttribute} to allow method chaining.
	###
	maxLength: (len) ->
		if typeof len isnt "number"
			throw new Error("Invalid length - expected Number, got #{typeof len}")
		unless NumberUtils.isPositiveInt(len)
			throw new Error("Maximum length must be an integer at least 1 in value")
		@options.maxLength = len
		return this
		
	###
	Sets the attribute's exact length.
	@param {Number} length number of characters.
	@return {StringAttribute} to allow method chaining.
	###
	length: (len) ->
		if typeof len isnt "number"
			throw new Error("Invalid length - expected Number, got #{typeof len}")
		unless NumberUtils.isPositiveInt(len)
			throw new Error("Exact length must be an integer at least 1 in value")
		@options.length = len
		return this

	###
	Sets a value the attribute must not equal to.
	@param {String} value
	@return {StringAttribute} to allow method chaining.
	###
	notEquals: (value) ->
		if typeof value isnt "string"
			throw new Error("Invalid value - expected String, got #{typeof value}")
		@options.notEquals = value
		return this

	###
	Sets the attribute's allowed values.
	@param {Array<String>} values
	@return {StringAttribute} to allow method chaining.
	###
	isIn: (values) ->
		if not Array.isArray(values)
			throw new Error("Invalid allowed values - expected Array, got #{typeof values}")
		if values.length is 0
			throw new Error("You must specify at least one allowed value")
		for value in values when typeof value isnt "string"
			throw new Error("Invalid allowed value - expected String, got #{typeof value}")
		@options.equals = values
		return this

	###
	Sets the attribute's prohibited values.
	@param {Array<String>} values
	@return {StringAttribute} to allow method chaining.
	###
	notIn: (values) ->
		if not Array.isArray(values)
			throw new Error("Invalid prohibited values - expected Array, got #{typeof values}")
		if values.length is 0
			throw new Error("You must specify at least one prohibited value")
		for value in values when typeof value isnt "string"
			throw new Error("Invalid prohibited value - expected String, got #{typeof value}")
		@options.notEquals = values
		return this

	###
	Sets a regex to match the attribute's value.
	@param {RegExp} re
	@return {StringAttribute} to allow method chaining.
	###
	regex: (re) ->
		unless re instanceof RegExp
			throw new Error("Invalid regular expression - expected RegExp, got #{typeof re}")
		@options.regex = re
		return this

	###
	Sets a regex to not match the attribute's value.
	@param {RegExp} re
	@return {StringAttribute} to allow method chaining.
	###
	notRegex: (re) ->
		unless re instanceof RegExp
			throw new Error("Invalid regular expression - expected RegExp, got #{typeof re}")
		@options.notRegex = re
		return this

	###
	Sets a string to contain in the attribute's value.
	@param {String} str
	@return {StringAttribute} to allow method chaining.
	###
	contains: (str) ->
		if typeof str isnt "string"
			throw new Error("Invalid string - expected String, got #{typeof str}")
		if str.length is 0
			throw new Error("String cannot be empty")
		@options.contains = str
		return this
		
	###
	Sets a string to not contain in the attribute's value.
	@param {String} str
	@return {StringAttribute} to allow method chaining.
	###
	notContains: (str) ->
		if typeof str isnt "string"
			throw new Error("Invalid string - expected String, got #{typeof str}")
		if str.length is 0
			throw new Error("String cannot be empty")
		@options.notContains = str
		return this

	###
	Parses the supplied value and returns a string or null.
	@param {*} value
	@return {String|null}
	###	
	parse: (value) ->
		if value?
			if typeof value is "string"
				return value
			else
				return value.toString()
		else
			return null

	###
	Throws an error if the specified value is invalid.
	@param {*} x
	@throw {Error} if value is invalid.
	###	
	validate: (value) ->
		value = this.parse(value)# parse this value
		if value isnt null
			# Min length
			if @options.minLength? and value.length < @options.minLength
				throw new Error("Attribute #{@name} must be at least #{@options.minLength} characters in length")
			# Max length
			if @options.maxLength? and value.length < @options.maxLength
				throw new Error("Attribute #{@name} must be at most #{@options.maxLength} characters in length")
			# Exact length
			if @options.length? and value.length isnt @options.length
				throw new Error("Attribute #{@name} must be exactly #{@options.length} characters in length")
			# Value equals
			if @options.equals? and value isnt @options.equals and value not in @options.equals
				throw new Error("Attribute #{@name} must be equal to an allowed value")
			# Value not equals
			if @options.notEquals? and (value is @options.notEquals or value in @options.notEquals)
				throw new Error("Attribute #{@name} cannot be equal to a prohibited value")
			# Value matches RegExp
			if @options.regex? and not @options.regex.test(value)
				throw new Error("Attribute #{@name} must match the regular expression #{@options.regex.toString()}")
			# Value not matches RegExp
			if @options.notRegex? and @options.notRegex.test(value)
				throw new Error("Attribute #{@name} cannot match the regular expression #{@options.notRegex.toString()}")
			# Value contains
			if @options.contains? and value.indexOf(@options.contains) is -1
				throw new Error("Attribute #{@name} must contain the value #{@options.contains}")
			# Value not contains
			if @options.notContains? and value.indexOf(@options.notContains) isnt -1
				throw new Error("Attribute #{@name} cannot contain the value #{@options.notContains}")
		else if not @options.nullable
			throw new Error("Attribute #{@name} cannot be assigned with a null value")
		return

module.exports = StringAttribute