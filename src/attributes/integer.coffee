NumberAttribute = require("./number")

class IntegerAttribute extends NumberAttribute

	###
	Constructs a new integer attribute.
	@param {String} name the attribute's name.
	###
	constructor: (name) -> super(name, {
		scale: 0
	})
	
	###
	Always throws an error since integer attributes don't allow fractional digits.
	@throw {Error}
	###
	scale: -> throw Error("Fractional digits are not allowed")

module.exports = IntegerAttribute