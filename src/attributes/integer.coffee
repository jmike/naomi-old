NumberAttribute = require("./number")

###
@extend NumberAttribute
@author Dimitrios C. Michalakos
###
class IntegerAttribute extends NumberAttribute

	###
	Constructs a new integer attribute.
	@param {Object} options key/value properties (optional).
	###
	constructor: (options = {}) ->
		Object.defineProperty(options, "scale", {
			value: 0
			writable: false
			enumerable: true
			configurable: false
		})
		super(options)

module.exports = IntegerAttribute