AbstractAttribute = require("./abstract")

###
@extend AbstractAttribute
@author Dimitrios C. Michalakos
###
class DateAttribute extends AbstractAttribute

	###
	Constructs a new DateAttribute instance.
	@param {Object} options key/value properties (optional).
	###
	constructor: (options = {}) ->
		super(options)

	###
	Sets the attribute's minimum allowed value.
	@param {Date} value
	@return {DateAttribute} to allow method chaining.
	###
	min: (value) ->
		unless value instanceof Date
			throw new Error("Invalid value - expected Date, got #{typeof value}")
		@options.min = value
		return this
		
	###
	Sets the attribute's maximum allowed value.
	@param {Date} value
	@return {DateAttribute} to allow method chaining.
	###
	max: (value) ->
		unless value instanceof Date
			throw new Error("Invalid value - expected Date, got #{typeof value}")
		@options.max = value
		return this

	###
	Sets the attribute's prohibited value.
	@param {Date} value
	@return {DateAttribute} to allow method chaining.
	###
	notEquals: (value) ->
		unless value instanceof Date
			throw new Error("Invalid value - expected Date, got #{typeof value}")
		@options.notEquals = value
		return this

	###
	Sets the attribute's allowed values.
	@param {Array<Date>} values
	@return {DateAttribute} to allow method chaining.
	###
	isIn: (values) ->
		if not Array.isArray(values)
			throw new Error("Invalid allowed values - expected Array, got #{typeof values}")
		if values.length is 0
			throw new Error("You must specify at least one allowed value")
		for value in values when not value instanceof Date
			throw new Error("Invalid allowed value - expected Date, got #{typeof value}")
		@options.isIn = values
		return this

	###
	Sets the attribute's prohibited values.
	@param {Array<Date>} values
	@return {DateAttribute} to allow method chaining.
	###
	notIn: (values) ->
		if not Array.isArray(values)
			throw new Error("Invalid prohibited values - expected Array, got #{typeof values}")
		if values.length is 0
			throw new Error("You must specify at least one prohibited value")
		for value in values when not value instanceof Date
			throw new Error("Invalid prohibited value - expected Date, got #{typeof value}")
		@options.notIn = values
		return this

	###
	Parses the supplied value and returns a Date object or null.
	@param {*} value
	@return {Date|null}
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
	@param {*} x
	@throw {Error} if value is invalid.
	###
	validate: (x) ->
		if not x instanceof Date
			x = new Date(x)
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

module.exports = DateAttribute