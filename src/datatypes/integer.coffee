NumberDatatype = require("./number")

###
@extend NumberDatatype
@author Dimitrios C. Michalakos
###
class IntegerDatatype extends NumberDatatype

	###
	Constructs a new integer datatype.
	@param {Object} properties key/value properties (optional).
    @option options {Boolean} nullable
    @option options {Number} precision
    @option options {Number} min
    @option options {Number} max
    @option options {Array.<Number>} equals
    @option options {Array.<Number>} notEquals
	###
	constructor: (properties = {}) ->
		super(properties)

		# Hardcode the scale in the datatype
		Object.defineProperty(@properties, "scale", {
			value: 0
			writable: false
			enumerable: true
			configurable: false
		})

	###
	Parses the supplied value and returns an integer or null or NaN.
	@param {*} value
	@return {Number, null, NaN}
	###
	@parse: (value) ->
		if value?
			return parseInt(value, 10)
		else# null, undefined
			return null

module.exports = IntegerDatatype