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
	@number: -> new NumberDatatype()
	
	###
	Constructs and returns a new integer datatype.
	@return {Attribute.Integer}
	###
	@integer: -> new IntegerDatatype()
	
	###
	Constructs and returns a new string datatype.
	@return {Attribute.String}
	###
	@string: -> new StringDatatype()
	
	###
	Constructs and returns a new e-mail datatype.
	@return {Attribute.String}
	###
	@email: -> new EmailDatatype()
	
	###
	Constructs and returns a new boolean datatype.
	@return {Attribute.Boolean}
	###
	@bool: -> new BooleanDatatype()

	###
	Constructs and returns a new date datatype.
	@return {Attribute.Date}
	###
	@date: -> new DateDatatype()
	
module.exports = Attribute
	