AbstractDatatype = require("./abstract")
NumberUtils = require("../utils/number")

###
@extend AbstractDatatype
@author Dimitrios C. Michalakos
###
class NumberDatatype extends AbstractDatatype

	###
	Constructs a new number datatype.
	@param {Object} options key/value properties (optional).
	###
	constructor: (options = {}) ->
		super(options)
		
	###
	Sets the the maximum number of digits allowed in the datatype's value.
	@param {Number} x number of digits.
	@return {NumberDatatype} to allow method chaining.
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
	@return {NumberDatatype} to allow method chaining.
	###
	scale: (x) ->
		if typeof x isnt "number"
			throw new Error("Invalid scale value - expected Number, got #{typeof value}")
		unless NumberUtils.isNonNegativeInt(x)
			throw new Error("Number of digits cannot be negative")
		@options.scale = x
		return this

	###
	Sets the datatype's minimum allowed value.
	@param {Number} value
	@return {NumberDatatype} to allow method chaining.
	###
	min: (value) ->
		if typeof value isnt "number"
			throw new Error("Invalid value - expected Number, got #{typeof value}")
		@options.min = value
		return this
		
	###
	Sets the datatype's maximum allowed value.
	@param {Number} value
	@return {NumberDatatype} to allow method chaining.
	###
	max: (value) ->
		if typeof value isnt "number"
			throw new Error("Invalid value - expected Number, got #{typeof value}")
		@options.max = value
		return this
		
	###
	Sets the datatype's allowed value(s).
	@param {Number} values an infinite number of values separated by comma.
	@return {NumberDatatype} to allow method chaining.
	###
	equals: (values...) ->
		if values.length is 0
			throw new Error("You must specify at least one allowed value")
		for e in values when typeof e isnt "number"
			throw new Error("Invalid allowed value - expected number, got #{typeof e}")
		@options.equals = values
		return this

	###
	Sets the datatype's prohibited value(s).
	@param {Number} values an infinite number of values separated by comma.
	@return {NumberDatatype} to allow method chaining.
	###
	notEquals: (values...) ->
		if values.length is 0
			throw new Error("You must specify at least one prohibited value")
		for e in values when typeof e isnt "number"
			throw new Error("Invalid prohibited value - expected number, got #{typeof e}")
		@options.notEquals = values
		return this

	###
	Parses the supplied value and returns number or null.
	@param {*} value
	@return {Number, null, NaN}
	###
	@parse: (value) ->
		if value?
			return parseFloat(value)
		else# null, undefined
			return null

	###
	Throws an error if the specified value is invalid.
	@param {*} value
	@param {Boolean} parse indicates whether the specified value should be parsed before being validated, defaults to true.
	@throw {Error} if value is invalid.
	###
	validate: (value, parse = true)  ->
		if parse
			value = NumberDatatype.parse(value)# parse this value
		
		if value?
			if @options.min? and value < @options.min
				throw new Error("Datatype must be at least #{@options.min} in value")

			if @options.max? and value > @options.max
				throw new Error("Datatype must be at most #{@options.max} in value")

			if @options.equals? and value not in @options.equals
				throw new Error("Datatype should match an allowed value")

			if @options.notEquals? and value in @options.notEquals
				throw new Error("Datatype cannot match a prohibited value")

			if @options.precision?
				if value.toString().replace(/\.|,/, "").length > @options.precision
					throw new Error("Datatype must have at most #{@options.precision} digits")

			if @options.scale?
				arr = value.toString().split(/\.|,/)
				if arr[1]? and arr[1].length > @options.scale
					throw new Error("Datatype must have at most #{@options.scale} digits to the right of the decimal point")
		
		super(value)
		return

	###
	Parses the supplied value and returns number or null.
	@param {*} value
	@param {Boolean} validate indicates whether the result should be validated before being returned, defaults to true.
	@return {Boolean, null}
	###	
	parse: (value, validate = true) ->
		value = NumberDatatype.parse(value)
		if validate
			try
				this.validate(value, false)
			catch error
				throw error
		return value

module.exports = NumberDatatype