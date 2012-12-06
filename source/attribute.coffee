BooleanAttribute = require("./attributes/boolean")
DateAttribute = require("./attributes/date")
IntegerAttribute = require("./attributes/integer")
NumberAttribute = require("./attributes/number")
StringAttribute = require("./attributes/String")

###
Attribute can be used to effortesly construct an entity's attribute.
@author Dimitrios C. Michalakos
###
class Attribute

	###
	Constructs and returns a new number attribute of the specified name.
	@param {String} name
	@return {NumberAttribute}
	###
	@number: (name) -> new NumberAttribute(name)
	
	###
	Constructs and returns a new integer attribute of the specified name.
	@param {String} name
	@return {IntegerAttribute}
	###
	@integer: (name) -> new IntegerAttribute(name)
	
	###
	Constructs and returns a new string attribute of the specified name.
	@param {String} name
	@return {StringAttribute}
	###
	@string: (name) -> new StringAttribute(name)
	
	###
	Constructs and returns a new boolean attribute of the specified name.
	@param {String} name
	@return {BooleanAttribute}
	###
	@bool: (name) -> new BooleanAttribute(name)

	###
	Constructs and returns a new date attribute of the specified name.
	@param {String} name
	@return {DateAttribute}
	###
	@date: (name) -> new DateAttribute(name)
		
module.exports = Attribute

attr = Attribute.number("mitsos").min(1).max(5)
try
	attr.validate("6")
catch error
	console.error error
	