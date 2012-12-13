#if typeof define isnt "function" then define = require("amdefine")(module)

GenericAttribute = require("./generic")

###
BooleanAttribute represents a boolean attribute.
###
class BooleanAttribute extends GenericAttribute

	###
	Constructs a new BooleanAttribute instance.
	@param {String} name the attribute's name.
	###
	constructor: (name) ->
		super(name)

	###
	Sets the attribute's prohibited value.
	@param {Boolean} value
	@return {BooleanAttribute} to allow method chaining.
	###
	notEquals: (value) ->
		if typeof value isnt "boolean"
			throw new Error("Invalid value - expected Boolean, got #{typeof value}")
		@options.notEquals = value
		return this

	###
	Throws an error if the specified value is invalid.
	@param {*} x
	@throw {Error} if value is invalid.
	###	
	validate: (x) ->
		if typeof x isnt "boolean"
			x = /^(true|1)$/i.test(x) or x is 1
		# Value not equals ..
		if typeof @options.notEquals isnt "undefined" and x is @options.notEquals
			throw new Error("Attribute #{@name} must not be equal to #{@options.notEquals} in value")
		return

module.exports = BooleanAttribute