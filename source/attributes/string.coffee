GenericAttribute = require("./generic")
NumberUtils = require("../utils/number")

###
StringAttribute represents a string attribute.
###
class StringAttribute extends GenericAttribute

	###
	Constructs a new StringAttribute instance of the designated name.
	@param {String} name the attribute's name.
	###
	constructor: (name) ->
		super(name)
		
	###
	Sets the attribute's minimum length.
	@param {Number} len number of characters.
	@return {StringAttribute} to allow method chaining.
	###
	minLength: (len) ->
		if typeof len isnt "number"
			throw new Error("Invalid length - expected Number, got #{typeof len}")
		unless NumberUtils.isNonNegativeInt(len)
			throw new Error("Minimum length must be an integer at least 0 in value")
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
		@options.isIn = values
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
		@options.notIn = values
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
	Throws an error if the specified value is invalid.
	@param {*} x
	@throw {Error} if value is invalid.
	###	
	validate: (x) ->
		if typeof x isnt "string"
			x = x.toString()
		# Min length
		if @options.minLength? and x.length < @options.minLength
			throw new Error("Attribute #{@name} must be at least #{@options.minLength} characters in length")
		# Max length
		if @options.maxLength? and x.length < @options.maxLength
			throw new Error("Attribute #{@name} must be at most #{@options.maxLength} characters in length")
		# Exact length
		if @options.length? and x.length isnt @options.length
			throw new Error("Attribute #{@name} must be of #{@options.length} characters in length")
		# Value not equals ..
		if @options.notEquals? and x is @options.notEquals
			throw new Error("Attribute #{@name} must not be equal to #{@options.notEquals} in value")
		# Value in [..]
		if @options.isIn? and x not in @options.isIn
			throw new Error("Attribute #{@name} must be equal to one of the predefined allowed values")
		# Value not in [..]
		if @options.notIn? and x in @options.notIn
			throw new Error("Attribute #{@name} must not be equal to one of the predefined prohibited values")
		# Value matches RegExp
		if @options.regex? and not @options.regex.test(x)
			throw new Error("Attribute #{@name} must match the regular expression #{@options.regex.toString()}")
		# Value not matches RegExp
		if @options.notRegex? and @options.notRegex.test(x)
			throw new Error("Attribute #{@name} must not match the regular expression #{@options.notRegex.toString()}")
		# Value contains
		if @options.contains? and x.indexOf(@options.contains) is -1
			throw new Error("Attribute #{@name} must contain the value #{@options.contains}")
		# Value not contains
		if @options.notContains? and x.indexOf(@options.notContains) isnt -1
			throw new Error("Attribute #{@name} must not contain the value #{@options.notContains}")
		return

module.exports = StringAttribute