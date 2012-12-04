Naomi = require("./naomi")

class Attribute

	###
	Constructs a new attribute of the designated name and type.
	@param {String} name the attribute's name.
	@param {String} type the attribute's type.
	###
	constructor: (name, type = Naomi.STRING) ->
		if typeof name isnt "string"
			throw new Error("Invalid attribute name - expected String, got #{typeof name}")
		if name.length is 0
			throw new Error("Attribute name cannot be an empty string")
		if type not in [Naomi.STRING, Naomi.NUMBER, Naomi.DATE, Naomi.BOOLEAN]
			throw new Error("Invalid attribute type")
		@name = name
		@type = type
		
	isValid: (value) ->
		
		
class Attribute.Number extends Attribute

	constructor: (name) ->
		super(name, Naomi.NUMBER)
		
	###
	Sets the attribute's precision points.
	@param {Number} n the number of digits after the decimal point, a non-negative integer.
	@return {Attribute.Number} to allow method chaining.
	###
	precision: (n) ->
		if typeof n is "number" and n % 1 is 0 and n >= 0
			@precision = n
		else
			throw new Error("Invalid or unspecified precision")
		return this
		
	###
	Sets the attribute's minimum allowed value.
	@param {Number} value
	@return {Attribute.Number} to allow method chaining.
	###
	min: (value) ->
		if typeof value isnt "number"
			throw new Error("Invalid value - expected Number, got #{typeof value}")
		@min = value
		return this
		
	###
	Sets the attribute's maximum allowed value.
	@param {Number} value
	@return {Attribute.Number} to allow method chaining.
	###
	max: (value) ->
		if typeof value isnt "number"
			throw new Error("Invalid value - expected Number, got #{typeof value}")
		@max = value
		return this
		
	notEquals: (value) ->
		if typeof value isnt "number"
			throw new Error("Invalid value - expected Number, got #{typeof value}")
		@notEquals = value		
		return this
	
	isIn: (options) ->
		if not Array.isArray(options)
			throw new Error("Invalid options - expected Array, got #{typeof options}")
		for x in options when typeof x isnt "number"
			throw new Error("Invalid options value - expected Number, got #{typeof options}")
		@isIn = options
		return this
	
	notIn: (options) ->
		if not Array.isArray(options)
			throw new Error("Invalid options - expected Array, got #{typeof options}")
		for x in options when typeof x isnt "number"
			throw new Error("Invalid options value - expected Number, got #{typeof options}")
		@notIn = options
		return this
		
class Attribute.Integer extends Attribute.Number

	constructor: (name) ->
		super(name).precision(0)
	
	