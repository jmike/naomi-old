AbstractDatatype = require("./abstract")

###
@extend AbstractDatatype
@author Dimitrios C. Michalakos
###
class DateDatatype extends AbstractDatatype

	###
	Constructs a new date datatype.
	@param {Object} options key/value properties (optional).
	###
	constructor: (options = {}) ->
		super(options)

	###
	Sets the datatype's minimum allowed value.
	@param {Date} value
	@return {DateDatatype} to allow method chaining.
	###
	min: (value) ->
		unless value instanceof Date
			throw new Error("Invalid value - expected Date, got #{typeof value}")
		@options.min = value
		return this
		
	###
	Sets the datatype's maximum allowed value.
	@param {Date} value
	@return {DateDatatype} to allow method chaining.
	###
	max: (value) ->
		unless value instanceof Date
			throw new Error("Invalid value - expected Date, got #{typeof value}")
		@options.max = value
		return this
		
	###
	Sets the datatype's allowed value(s).
	@param {Date} values an infinite number of values separated by comma.
	@return {DateDatatype} to allow method chaining.
	###
	equals: (values...) ->
		if values.length is 0
			throw new Error("You must specify at least one allowed value")
		for e in values when not e instanceof Date
			throw new Error("Invalid allowed value - expected date, got #{typeof e}")
		@options.equals = values
		return this

	###
	Sets the datatype's prohibited value(s).
	@param {Date} values an infinite number of values separated by comma.
	@return {DateDatatype} to allow method chaining.
	###
	notEquals: (values...) ->
		if values.length is 0
			throw new Error("You must specify at least one prohibited value")
		for e in values when not e instanceof Date
			throw new Error("Invalid prohibited value - expected date, got #{typeof e}")
		@options.notEquals = values
		return this

	###
	Parses the supplied value to match the datatype's native internal type.
	@param {*} value
	@return {Date, null}
	###
	@parse: (value) ->
		if value?
			if value instanceof Date
				return value
			else
				return new Date(value)
		else
			return null

	###
	Throws an error if the specified value is invalid.
	@param {*} value
	@throw {Error} if value is invalid.
	###
	validate: (value) ->
		value = DateDatatype.parse(value)

		if value?
			if @options.min? and value < @options.min
				throw new Error("Datatype must be at least #{@options.min} in value")

			if @options.max? and value > @options.max
				throw new Error("Datatype must be at most #{@options.max} in value")

			if @options.equals? and value not in @options.equals
				throw new Error("Datatype should match an allowed value")

			if @options.notEquals? and value in @options.notEquals
				throw new Error("Datatype cannot match a prohibited value")
								
		super(value)
		return

module.exports = DateDatatype