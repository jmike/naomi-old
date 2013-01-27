AbstractAttribute = require("./abstract")
NumberUtils = require("../utils/number")

###
@extend AbstractAttribute
@author Dimitrios C. Michalakos
###
class NumberAttribute extends AbstractAttribute

	###
	Constructs a new number attribute.
	@param {Object} options key/value properties (optional).
	###
	constructor: (options = {}) ->
		super(options)
		
	###
	Sets the the maximum number of digits allowed in the attribute's value.
	@param {Number} x number of digits.
	@return {NumberAttribute} to allow method chaining.
	###
	precision: (x) ->
		if typeof x isnt "number"
			throw new Error("Invalid precision value - expected Number, got #{typeof value}")
		unless NumberUtils.isNonNegativeInt(x)
			throw new Error("Number of digits cannot be negative")
		@options.precision = x
		return this

	###
	Sets the the maximum number of digits allowed to the right of a decimal point.
	@param {Number} x number of digits.
	@return {NumberAttribute} to allow method chaining.
	###
	scale: (x) ->
		if typeof x isnt "number"
			throw new Error("Invalid scale value - expected Number, got #{typeof value}")
		unless NumberUtils.isNonNegativeInt(x)
			throw new Error("Number of digits cannot be negative")
		@options.scale = x
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
	Sets a list of allowed values for this attribute.
	@param {Array<Number>} values
	@return {NumberAttribute} to allow method chaining.
	###
	isIn: (values) ->
		if not Array.isArray(values)
			throw new Error("Invalid allowed values - expected an Array, got #{typeof values}")
		if values.length is 0
			throw new Error("You must specify at least one allowed value")
		for value in values when typeof value isnt "number"
			throw new Error("Invalid allowed value - expected Number, got #{typeof value}")
		@options.equals = values
		return this

	###
	Sets a list of prohibited values for this attribute.
	@param {Array<Number>} values
	@return {NumberAttribute} to allow method chaining.
	###
	notIn: (values) ->
		if not Array.isArray(values)
			throw new Error("Invalid prohibited values - expected an Array, got #{typeof values}")
		if values.length is 0
			throw new Error("You must specify at least one prohibited value")
		for value in values when typeof value isnt "number"
			throw new Error("Invalid prohibited value - expected Number, got #{typeof value}")
		@options.notEquals = values
		return this
	
	###
	Parses the supplied value to match the attribute's native internal type.
	@param {*} value
	@return {Number|null|NaN}
	###
	@parse: (value) ->
		if value?
			if typeof value is "number"
				return value
			else
				return parseFloat(value)
		else# null, undefined
			return null

	###
	Parses the supplied value to match the attribute's native internal type.
	@param {*} value
	@return {Number|null|NaN}
	###
	parse: @parse

	###
	Throws an error if the specified value is invalid.
	@param {*} value
	@throw {Error} if value is invalid.
	###	
	validate: (value) ->
		value = NumberAttribute.parse(value)# parse this value
		if value isnt null
			# Min value
			if @options.min? and value < @options.min
				throw new Error("Attribute #{@name} must be at least #{@options.min} in value")
			# Max value
			if @options.max? and value > @options.max
				throw new Error("Attribute #{@name} must be at most #{@options.max} in value")
			# Value equals
			if @options.equals? and value isnt @options.equals and value not in @options.equals
				throw new Error("Attribute #{@name} must be equal to an allowed value")
			# Value not equals
			if @options.notEquals? and (value is @options.notEquals or value in @options.notEquals)
				throw new Error("Attribute #{@name} cannot be equal to a prohibited value")
			# Precision
			if @options.precision?
				if value.toString().replace(/\.|,/, "").length > @options.precision
					throw new Error("Attribute #{@name} must be at most #{@options.precision} digits in length")
			# Scale
			if @options.scale?
				arr = value.toString().split(/\.|,/)
				if arr[1]? and arr[1].length > @options.scale
					throw new Error("Attribute #{@name} must have at most #{@options.scale} digits to right of the decimal point")
		else if not @options.nullable
			throw new Error("Attribute #{@name} cannot be assigned with a null value")
		return

module.exports = NumberAttribute