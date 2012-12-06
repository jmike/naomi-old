Naomi = require("./naomi")
check = require("validator").check

###
Returns true if the supplied value is an integer.
@param {*} x
@return {Boolean}
@private
###
isInt = (x) -> typeof x is "number" and x % 1 is 0

###
Returns true if the supplied value is a non negative integer (including zero).
@param {*} x
@return {Boolean}
@private
###
isNonNegativeInt = (x) -> isInt(x) and x >= 0

###
Returns true if the supplied value is a positive integer (excluding zero).
@param {*} x
@return {Boolean}
@private
###
isPositiveInt = (x) -> isInt(x) and x > 0

###
Attribute can be used to effortesly construct an entity's attribute.
@author Dimitrios C. Michalakos
###
class Attribute

	###
	Constructs and returns a new Attribute.Number instance.
	@param {String} name
	@return {Attribute.Number}
	###
	@number: (name) -> new Attribute.Number(name)
	
	###
	Constructs and returns a new Attribute.Integer instance.
	@param {String} name
	@return {Attribute.Integer}
	###
	@integer: (name) -> new Attribute.Integer(name)
	
	###
	Constructs and returns a new Attribute.String instance.
	@param {String} name
	@return {Attribute.String}
	###
	@string: (name) -> new Attribute.String(name)

	###
	Constructs a new attribute of the designated name, type and constraints.
	@param {String} name the attribute's name.
	@param {String} type the attribute's type (optional).
	@param {Object} options key/value constraints (optional)
	###
	constructor: (name, type = Naomi.STRING, options = {}) ->
		if typeof name isnt "string"
			throw new Error("Invalid attribute name - expected String, got #{typeof name}")
		if name.length is 0
			throw new Error("Attribute name cannot be empty")
		if type not in [Naomi.STRING, Naomi.NUMBER, Naomi.DATE, Naomi.BOOLEAN]
			throw new Error("Unknown attribute type")
		@name = name
		@type = type
		@options = options
	
	###
	Returns void if the specified value is valid.
	@param {*} x
	@throw {Error} if value is invalid.
	###	
	validate: (x) ->
		test = check(x, "Invalid value for attribute #{@name}")
		# Length
		if @options.length?
			test.len(@options.length, @options.length)
		else if @options.minLength?
			test.len(@options.minLength, @options.maxLength)
		else if @options.maxLength?
			test.len(0, @options.maxLength)
		# Min/max value
		if @options.min?
			test.min(@options.min)
		if @options.max?
			test.max(@options.max)

###
Attribute.String represents a string attribute.
###
class Attribute.String extends Attribute

	###
	Constructs a new Attribute.String instance.
	@param {String} name the attribute's name.
	###
	constructor: (name) ->
		super(name, Naomi.String)
		
	###
	Sets the attribute's minimum length.
	@param {Number} n number of characters.
	@return {Attribute.String} to allow method chaining.
	###
	minLength: (n) ->
		unless isNonNegativeInt(n)
			throw new Error("Invalid or unspecified minimum length")
		@options.minLength = n
		return this
		
	###
	Sets the attribute's maximum length.
	@param {Number} length number of characters.
	@return {Attribute.String} to allow method chaining.
	###
	maxLength: (n) ->
		unless isNonNegativeInt(n)
			throw new Error("Invalid or unspecified maximum length")
		@options.maxLength = n
		return this
		
	###
	Sets the attribute's exact length.
	@param {Number} length number of characters.
	@return {Attribute.String} to allow method chaining.
	###
	length: (n) ->
		unless isNonNegativeInt(n)
			throw new Error("Invalid or unspecified maximum length")
		@options.length = n
		return this

	###
	Sets the attribute's prohibited value.
	@param {String} value
	@return {Attribute.String} to allow method chaining.
	###
	notEquals: (value) ->
		if typeof value isnt "string"
			throw new Error("Invalid value - expected String, got #{typeof value}")
		@options.notEquals = value
		return this

	###
	Sets a list of the attribute's allowed values.
	@param {Array<String>} values
	@return {Attribute.String} to allow method chaining.
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
	Sets a list of the attribute's prohibited values.
	@param {Array<String>} values
	@return {Attribute.String} to allow method chaining.
	###
	notIn: (values) ->
		if not Array.isArray(values)
			throw new Error("Invalid prohibited values - expected Array, got #{typeof values}")
		if values.length is 0
			throw new Error("You must specify at least one prohibited value")
		for value in values when typeof value isnt "string"
			throw new Error("Invalid allowed value - expected String, got #{typeof value}")
		@options.notIn = values
		return this

	###
	Sets a regex to match the attribute's allowed values.
	@param {RegExp} re
	@return {Attribute.String} to allow method chaining.
	###
	regex: (re) ->
		unless re instanceof RegExp
			throw new Error("Invalid regural expression - expected RegExp, got #{typeof re}")
		@options.regex = re
		return this

	###
	Sets a regex to match the attribute's prohibited values.
	@param {RegExp} re
	@return {Attribute.String} to allow method chaining.
	###
	notRegex: (re) ->
		unless re instanceof RegExp
			throw new Error("Invalid regural expression - expected RegExp, got #{typeof re}")
		@options.notRegex = re
		return this

	###
	Sets a string to contain in the attribute's allowed values.
	@param {String} str
	@return {Attribute.String} to allow method chaining.
	###
	contains: (str) ->
		if typeof str isnt "string"
			throw new Error("Invalid value - expected String, got #{typeof str}")
		if str.length is 0
			throw new Error("String to contain cannot be empty")
		@options.contains = str
		return this
		
	###
	Sets a string to not contain in the attribute's allowed values.
	@param {String} str
	@return {Attribute.String} to allow method chaining.
	###
	notContains: (str) ->
		if typeof str isnt "string"
			throw new Error("Invalid value - expected String, got #{typeof str}")
		if str.length is 0
			throw new Error("String to not contain cannot be empty")
		@options.notContains = str
		return this

###
Attribute.Number represents a numeric attribute.
###
class Attribute.Number extends Attribute

	###
	Constructs a new Attribute.Number instance.
	@param {String} name the attribute's name.
	###
	constructor: (name) ->
		super(name, Naomi.NUMBER)
		
	###
	Sets the attribute's precision.
	@param {Number} x number of digits after the decimal point.
	@return {Attribute.Number} to allow method chaining.
	###
	precision: (x) ->
		unless isNonNegativeInt(x)
			throw new Error("Invalid or unspecified precision")
		@options.precision = x	
		return this
		
	###
	Sets the attribute's minimum allowed value.
	@param {Number} value
	@return {Attribute.Number} to allow method chaining.
	###
	min: (value) ->
		if typeof value isnt "number"
			throw new Error("Invalid value - expected Number, got #{typeof value}")
		@options.min = value
		return this
		
	###
	Sets the attribute's maximum allowed value.
	@param {Number} value
	@return {Attribute.Number} to allow method chaining.
	###
	max: (value) ->
		if typeof value isnt "number"
			throw new Error("Invalid value - expected Number, got #{typeof value}")
		@options.max = value
		return this

	###
	Sets the attribute's prohibited value.
	@param {Number} value
	@return {Attribute.Number} to allow method chaining.
	###
	notEquals: (value) ->
		if typeof value isnt "number"
			throw new Error("Invalid value - expected Number, got #{typeof value}")
		@options.notEquals = value
		return this

	###
	Sets a list of the attribute's allowed values.
	@param {Array<Number>} values
	@return {Attribute.Number} to allow method chaining.
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
	Sets a list of the attribute's prohibited values.
	@param {Array<Number>} values
	@return {Attribute.Number} to allow method chaining.
	###
	notIn: (values) ->
		if not Array.isArray(values)
			throw new Error("Invalid prohibited values - expected Array, got #{typeof values}")
		if values.length is 0
			throw new Error("You must specify at least one prohibited value")
		for value in values when typeof value isnt "number"
			throw new Error("Invalid allowed value - expected Number, got #{typeof value}")
		@options.notIn = values
		return this

###
Attribute.Number represents an integer attribute.
###
class Attribute.Integer extends Attribute.Number

	###
	Constructs a new Attribute.Integer instance.
	@param {String} name the attribute's name.
	###
	constructor: (name) ->
		super(name).precision(0)
		
module.exports = Attribute

attr = Attribute.number("mitsos").min(1).max(5)
try
	attr.validate(3)
catch error
	console.error error
	