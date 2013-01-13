GenericAttribute = require("./generic")

###
BooleanAttribute represents a boolean attribute of an entity.
###
class BooleanAttribute extends GenericAttribute

	###
	Constructs a new boolean attribute.
	@param {String} name the attribute's name.
	@param {Object} options key/value constraints (optional).
	###
	constructor: (name, options = {}) ->
		super(name, options)

	###
	Parses the supplied value and returns a boolean or null.
	@param {*} value
	@return {Boolean|null}
	###	
	parse: (value) ->
		if value?
			if typeof value is "boolean"
				return value
			else
				return /^(true|1)$/i.test(value) or value is 1
		else
			return null

module.exports = BooleanAttribute