NumberAttribute = require("./number")

class IntegerAttribute extends NumberAttribute

	###
	Constructs a new integer attribute.
	@param {String} name the attribute's name.
	###
	constructor: (name) -> super(name, {
		scale: 0
	})

module.exports = IntegerAttribute