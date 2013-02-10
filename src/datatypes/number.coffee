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
	###
	constructor: (properties = {}) ->
		super(properties)
		
	###
	@overload precision()
	  Returns the the maximum number of digits allowed in the datatype's value.
	  @return {Number}
	@overload precision(value)
	  Sets the the maximum number of digits allowed in the datatype's value.
	  @param {Number} value number of digits, cannot be negative or zero.
	  @return {NumberDatatype} to allow method chaining.
	###
	precision: (value) ->
		switch typeof value
			when "undefined"
				return @_properties.precision
			when "number"
				if NumberUtils.isPositiveInt(value)
					@_properties.precision = value
					return this
				else
					throw new Error("Invalid precision value - cannot be negative or zero")
			else
				throw new Error("Invalid precision value - expected Number, got #{typeof value}")

	###
	@overload scale()
	  Returns the the maximum number of digits allowed to the right of a decimal point.
	  @return {Number}
	@overload scale(value)
	  Sets the the maximum number of digits allowed to the right of a decimal point.
	  @param {Number} value number of digits.
	  @return {NumberDatatype} to allow method chaining.
	###
	scale: (value) ->
		switch typeof value
			when "undefined"
				return @_properties.scale
			when "number"
				if NumberUtils.isNonNegativeInt(value)
					@_properties.scale = value
					return this
				else
					throw new Error("Invalid scale value - cannot be negative")
			else
				throw new Error("Invalid scale value - expected Number, got #{typeof value}")

	###
	@overload min()
	  Returns the datatype's minimum allowed value.
	  @return {Number}
	@overload min(value)
	  Sets the datatype's minimum allowed value.
	  @param {Number} value
	  @return {NumberDatatype} to allow method chaining.
	###
	min: (value) ->
		switch typeof value
			when "undefined"
				return @_properties.min
			when "number"
				@_properties.min = value
				return this
			else
				throw new Error("Invalid value - expected Number, got #{typeof value}")
		
	###
	@overload max()
	  Returns the datatype's maximum allowed value.
	  @return {Number}
	@overload max(value)
	  Sets the datatype's maximum allowed value.
	  @param {Number} value
	  @return {NumberDatatype} to allow method chaining.
	###
	max: (value) ->
		switch typeof value
			when "undefined"
				if @_properties.max?
					return @_properties.max
				else if @_properties.equals?
					return Math.max.apply(Math, @_properties.equals);
				else if @_properties.precision?
					return Math.pow(10, @_properties.precision - (@_properties.scale || 0)) - 1 / 
						Math.pow(10, (@_properties.scale || 0))
				else
					return undefined
			when "number"
				@_properties.max = value
				return this
			else
				throw new Error("Invalid value - expected Number, got #{typeof value}")
		
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
		@_properties.equals = values
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
		@_properties.notEquals = values
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
	@param {Boolean} parse indicates whether the specified value should be parsed, defaults to true.
	@throw {Error} if value is invalid.
	###
	validate: (value, parse = true)  ->
		if parse
			value = NumberDatatype.parse(value)# parse this value
		
		if value?
			if @_properties.min? and value < @_properties.min
				throw new Error("Datatype must be at least #{@_properties.min} in value")

			if @_properties.max? and value > @_properties.max
				throw new Error("Datatype must be at most #{@_properties.max} in value")

			if @_properties.equals? and value not in @_properties.equals
				throw new Error("Datatype should match an allowed value")

			if @_properties.notEquals? and value in @_properties.notEquals
				throw new Error("Datatype cannot match a prohibited value")

			if @_properties.precision?
				if value.toString().replace(/\.|,/, "").length > @_properties.precision
					throw new Error("Datatype must have at most #{@_properties.precision} digits")

			if @_properties.scale?
				arr = value.toString().split(/\.|,/)
				if arr[1]? and arr[1].length > @_properties.scale
					throw new Error("Datatype must have at most #{@_properties.scale} digits to the right of the decimal point")
		
		super(value)
		return

	###
	Parses the supplied value and returns number or null.
	@param {*} value
	@param {Boolean} validate indicates whether the value should be validated, defaults to true.
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