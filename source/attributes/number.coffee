GenericAttribute = require("./generic")
NumberUtils = require("../utils/number")

###
NumberAttribute represents a numeric attribute.
###
class NumberAttribute extends GenericAttribute

	###
	Constructs a new NumberAttribute instance.
	@param {String} name the attribute's name.
	###
	constructor: (name) ->
		super(name)
		
	###
	Sets the attribute's precision.
	@param {Number} x number of digits after the decimal point.
	@return {NumberAttribute} to allow method chaining.
	###
	precision: (x) ->
		if typeof x isnt "number"
			throw new Error("Invalid number of fractional digits - expected Number, got #{typeof value}")
		unless NumberUtils.isNonNegativeInt(x)
			throw new Error("Number of fractional digits must an integer of at least 0 in value")
		@options.precision = x	
		return this
		
	###
	Sets the attribute's minimum allowed value.
	@param {Number} value
	@return {NumberAttribute} to allow method chaining.
	###
	min: (value) ->
		if typeof value isnt "number"
			throw new Error("Invalid value - expected Number, got #{typeof value}")
		@options.min = value
		return this
		
	###
	Sets the attribute's maximum allowed value.
	@param {Number} value
	@return {NumberAttribute} to allow method chaining.
	###
	max: (value) ->
		if typeof value isnt "number"
			throw new Error("Invalid value - expected Number, got #{typeof value}")
		@options.max = value
		return this

	###
	Sets the attribute's prohibited value.
	@param {Number} value
	@return {NumberAttribute} to allow method chaining.
	###
	notEquals: (value) ->
		if typeof value isnt "number"
			throw new Error("Invalid value - expected Number, got #{typeof value}")
		@options.notEquals = value
		return this

	###
	Sets the attribute's allowed values.
	@param {Array<Number>} values
	@return {NumberAttribute} to allow method chaining.
	###
	isIn: (values) ->
		if not Array.isArray(values)
			throw new Error("Invalid allowed values - expected Array, got #{typeof values}")
		if values.length is 0
			throw new Error("You must specify at least one allowed value")
		for value in values when typeof value isnt "number"
			throw new Error("Invalid allowed value - expected Number, got #{typeof value}")
		@options.isIn = values
		return this

	###
	Sets the attribute's prohibited values.
	@param {Array<Number>} values
	@return {NumberAttribute} to allow method chaining.
	###
	notIn: (values) ->
		if not Array.isArray(values)
			throw new Error("Invalid prohibited values - expected Array, got #{typeof values}")
		if values.length is 0
			throw new Error("You must specify at least one prohibited value")
		for value in values when typeof value isnt "number"
			throw new Error("Invalid prohibited value - expected Number, got #{typeof value}")
		@options.notIn = values
		return this

	###
	Throws an error if the specified value is invalid.
	@param {*} x
	@throw {Error} if value is invalid.
	###	
	validate: (x) ->
		if typeof x isnt "number"
			x = parseFloat(x)
		# Decimal precision
		if @options.precision?
			arr = x.toString().split(/\.|,/)
			if arr[1]? and arr[1].length > @options.precision
				throw new Error("Attribute #{@name} must have #{@options.precision} fractional digits")
		# Min value
		if @options.min? and x < @options.min
			throw new Error("Attribute #{@name} must be at least #{@options.min} in value")
		# Max value
		if @options.max? and x > @options.max
			throw new Error("Attribute #{@name} must be at most #{@options.max} in value")
		# Value not equals ..
		if @options.notEquals? and x is @options.notEquals
			throw new Error("Attribute #{@name} must not be equal to #{@options.notEquals} in value")
		# Value in [..]
		if @options.isIn? and x not in @options.isIn
			throw new Error("Attribute #{@name} must be equal to one of the predefined allowed values")
		# Value not in [..]
		if @options.notIn? and x in @options.notIn
			throw new Error("Attribute #{@name} must not be equal to one of the predefined prohibited values")
		return

module.exports = NumberAttribute