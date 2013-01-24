GenericAttribute = require("./generic")

class BooleanAttribute extends GenericAttribute

	###
	Constructs a new boolean attribute of the specified properties.
	@param {String} name the attribute's name.
	@param {Object} options key/value constraints (optional).
	###
	constructor: (name, options = {}) ->
		super(name, options)

	###
	Parses the supplied value to match the attribute's internal type.
	@param {*} value
	@return {Boolean|null}
	###	
	parse: (value) ->
		if value?
			switch typeof value
				when "boolean"
					return value
				when "string", "number"
					return /^(true|1)$/i.test(value) or value is 1
				else
					return Boolean(value)
		else# null or undefined
			return null

module.exports = BooleanAttribute