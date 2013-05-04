AbstractDatatype = require("./abstract")
NumberUtils = require("../utils/number")

###
@extend AbstractDatatype
@author Dimitrios C. Michalakos
###
class NumberDatatype extends AbstractDatatype

	###
	Constructs a new number datatype.
	@param {Object} properties key/value properties (optional).
    @option options {Boolean} nullable
    @option options {Number} precision
    @option options {Number} scale
    @option options {Number} min
    @option options {Number} max
    @option options {Array.<Number>} equals
    @option options {Array.<Number>} notEquals
	###
	constructor: (properties = {}) ->
		super(properties)
		
	###
	@overload precision()
	  Returns the maximum number of digits allowed in the datatype.
	  @return {Number}
	@overload precision(value)
	  Sets the maximum number of digits allowed in the datatype.
	  @param {Number} value number of digits, cannot be negative or zero.
	  @return {NumberDatatype} to allow method chaining.
      @throw {Error} if the supplied value is invalid.
	###
	precision: (value) ->
		switch typeof value
			when "undefined"
				return @properties.precision

			when "number"
				if NumberUtils.isPositiveInt(value)
					@properties.precision = value
				else
					throw new Error("Invalid precision value: cannot be negative or zero")
				return this

			else
				throw new Error("Invalid precision value: expected number, got #{typeof value}")

	###
	@overload scale()
	  Returns the maximum number of digits allowed to the right of a decimal point.
	  @return {Number}
	@overload scale(value)
	  Sets the maximum number of digits allowed to the right of a decimal point.
	  @param {Number} value number of digits.
	  @return {NumberDatatype} to allow method chaining.
      @throw {Error} if the supplied value is invalid.
	###
	scale: (value) ->
		switch typeof value
			when "undefined"
				return @properties.scale

			when "number"
				unless NumberUtils.isNonNegativeInt(value)
					throw new Error("Invalid scale value: cannot be negative")
				if value + 1 > @properties.precision
					throw new Error("Invalid scale value: cannot be greater than precision - 1")
				@properties.scale = value
				return this

			else
				throw new Error("Invalid scale value: expected number, got #{typeof value}")

	###
	@overload min()
	  Returns the datatype's minimum allowed value.
	  @return {Number}
	@overload min(value)
	  Sets the datatype's minimum allowed value.
	  @param {Number} value
	  @return {NumberDatatype} to allow method chaining.
      @throw {Error} if the supplied value is invalid.
	###
	min: (value) ->
		switch typeof value
			when "undefined"
				if @properties.min?
					return @properties.min
				else if @properties.equals?
					return Math.min.apply(Math, @properties.equals)
				else if @properties.precision?
					return -1 * (Math.pow(10, @properties.precision - (@properties.scale || 0)) - 1 / Math.pow(10, (@properties.scale || 0)))# greatest negative allowed
				else
					return undefined

			when "number"
				if value > @properties.max
					throw new Error("Invalid minimum value: cannot be greater than maximum value")
				else
					@properties.min = value
				return this

			else
				throw new Error("Invalid minimum value: expected number, got #{typeof value}")
		
	###
	@overload max()
	  Returns the datatype's maximum allowed value.
	  @return {Number}
	@overload max(value)
	  Sets the datatype's maximum allowed value.
	  @param {Number} value
	  @return {NumberDatatype} to allow method chaining.
      @throw {Error} if the supplied value is invalid.
	###
	max: (value) ->
		switch typeof value
			when "undefined"
				if @properties.max?
					return @properties.max
				else if @properties.equals?
					return Math.max.apply(Math, @properties.equals)
				else if @properties.precision?
					return Math.pow(10, @properties.precision - (@properties.scale || 0)) - 1 / Math.pow(10, (@properties.scale || 0))# greatest positive allowed
				else
					return undefined

			when "number"
				if value < @properties.min
					throw new Error("Invalid maximum value: cannot be less than minimum value")
				else
					@properties.max = value
				return this

			else
				throw new Error("Invalid maximum value: expected number, got #{typeof value}")
		
	###
	@overload equals()
	  Returns an array of datatype allowed values.
	  @return {Array.<Number>}
	@overload equals(values...)
	  Sets the datatype's allowed values.
	  @param {Number} values an infinite number of values separated by comma.
	  @return {NumberDatatype} to allow method chaining.
      @throw {Error} if the supplied values are invalid.
	###
	equals: (values...) ->
		if values.length is 0
			return @properties.equals

		else
			for e in values when typeof e isnt "number"
				throw new Error("Invalid allowed value: expected number, got #{typeof e}")
			@properties.equals = values
			return this

	###
	@overload notEquals()
	  Returns an array of datatype prohibited values.
	  @return {Array.<Number>}
	@overload notEquals(values...)
	  Sets the datatype's prohibited values.
	  @param {Number} values an infinite number of values separated by comma.
	  @return {NumberDatatype} to allow method chaining.
      @throw {Error} if the supplied values are invalid.
	###
	notEquals: (values...) ->
		if values.length is 0
			return @properties.notEquals

		else
			for e in values when typeof e isnt "number"
				throw new Error("Invalid prohibited value: expected number, got #{typeof e}")
			@properties.notEquals = values
			return this

	###
	Parses the supplied value and returns number or null or NaN.
	@param {*} value
	@return {Number, null, NaN}
	###
	@parse: (value) ->
		if value?
			return parseFloat(value)
		else# null, undefined
			return null

	###
	Throws an error if the specified value cannot be assigned to the datatype.
	@param {*} value
	@param {Boolean} parse indicates whether the specified value should be parsed before being validated, defaults to true.
	@throw {Error} if value is invalid.
	###
	validate: (value, parse = true)  ->
		if parse
			value = NumberDatatype.parse(value)# parse this value
		
		if value?
			if @properties.min? and value < @properties.min
				throw new Error("Datatype must be at least #{@properties.min} in value")

			if @properties.max? and value > @properties.max
				throw new Error("Datatype must be at most #{@properties.max} in value")

			if @properties.equals? and value not in @properties.equals
				throw new Error("Datatype should match an allowed value")

			if @properties.notEquals? and value in @properties.notEquals
				throw new Error("Datatype cannot match a prohibited value")

			if @properties.precision?
				if value.toString().replace(/\.|,/, "").length > @properties.precision
					throw new Error("Datatype must have at most #{@properties.precision} digits")

			if @properties.scale?
				arr = value.toString().split(/\.|,/)
				if arr[1]? and arr[1].length > @properties.scale
					throw new Error("Datatype must have at most #{@properties.scale} digits to the right of the decimal point")
		
		super(value)
		return

	###
	Parses the supplied value and returns number or null.
	@param {*} value
	@return {Boolean, null}
    @throw {Error} if value is invalid.
	###	
	parse: (value) ->
		value = NumberDatatype.parse(value)

		try
			this.validate(value, false)
		catch error
			throw error

		return value

module.exports = NumberDatatype