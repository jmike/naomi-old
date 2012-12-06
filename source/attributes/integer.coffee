NumberAttribute = require("./number")

###
IntegerAttribute represents an integer attribute.
###
class IntegerAttribute extends NumberAttribute

	###
	Constructs a new IntegerAttribute instance.
	@param {String} name the attribute's name.
	###
	constructor: (name) -> super(name, {
		precision: 0
	})

module.exports = IntegerAttribute