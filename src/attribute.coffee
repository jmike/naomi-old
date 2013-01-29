BooleanDatatype = require("./datatypes/boolean")
DateDatatype = require("./datatypes/date")
IntegerDatatype = require("./datatypes/integer")
NumberDatatype = require("./datatypes/number")
StringDatatype = require("./datatypes/string")
EmailDatatype = require("./datatypes/email")

###
@author Dimitrios C. Michalakos
###
class Attribute

	@Boolean = BooleanDatatype
	@Number = NumberDatatype
	@String = StringDatatype
	@Date = DateDatatype
	@Integer = IntegerDatatype
	@Email = EmailDatatype

	###
	Constructs and returns a new number datatype.
	@return {Attribute.Number}
	###
	@number: -> new @Number()
	
	###
	Constructs and returns a new integer datatype.
	@return {Attribute.Integer}
	###
	@integer: -> new @Integer()
	
	###
	Constructs and returns a new string datatype.
	@return {Attribute.String}
	###
	@string: -> new @String()
	
	###
	Constructs and returns a new boolean datatype.
	@return {Attribute.Boolean}
	###
	@boolean: -> new @Boolean()

	###
	Constructs and returns a new date datatype.
	@return {Attribute.Date}
	###
	@date: -> new @Date()
	
module.exports = Attribute
	