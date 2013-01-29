AbstractDatatype = require("./abstract")

###
@extend AbstractDatatype
@author Dimitrios C. Michalakos
###
class BooleanDatatype extends AbstractDatatype

	###
	Constructs a new boolean datatype.
	@param {Object} options key/value properties (optional).
	###
	constructor: (options = {}) ->
		super(options)

	###
	Parses the supplied value and returns a boolean or null.
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
	Throws an error if the specified value is invalid.
	@param {*} value
	@throw {Error} if value is invalid.
	###
	validate: (value) ->
		value = BooleanDatatype.parse(value)# parse this value
		super(value)
		return

module.exports = BooleanDatatype