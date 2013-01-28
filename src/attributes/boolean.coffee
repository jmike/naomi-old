AbstractAttribute = require("./abstract")

###
@extend AbstractAttribute
@author Dimitrios C. Michalakos
###
class BooleanAttribute extends AbstractAttribute

	###
	Constructs a new boolean attribute.
	@param {Object} options key/value properties (optional).
	###
	constructor: (options = {}) ->
		super(options)

	###
	Parses the supplied value to match the attribute's native internal type.
	@param {*} value
	@return {Boolean, null}
	###	
	@parse: (value) ->
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
	
	###
	Parses the supplied value to match the attribute's native internal type.
	@param {*} value
	@return {Boolean, null}
	###		
	parse: @parse

module.exports = BooleanAttribute