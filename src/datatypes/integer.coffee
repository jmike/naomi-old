NumberDatatype = require("./number")

###
@extend NumberDatatype
@author Dimitrios C. Michalakos
###
class IntegerDatatype extends NumberDatatype

	###
	Constructs a new integer datatype.
	@param {Object} options key/value properties (optional).
	###
	constructor: (options = {}) ->
		super(options)
		Object.defineProperty(@options, "scale", {
			value: 0
			writable: false
			enumerable: true
			configurable: false
		})

	###
	Parses the supplied value and returns an integer or NaN or null.
	@param {*} value
	@return {Number, null, NaN}
	###
	@parse: (value) ->
		if value?
			return parseInt(value, 10)
		else# null, undefined
			return null

module.exports = IntegerDatatype