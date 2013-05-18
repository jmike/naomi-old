BooleanDatatype = require("./boolean")
DateDatatype = require("./date")
IntegerDatatype = require("./integer")
NumberDatatype = require("./number")
TimeDatatype = require("./time")
StringDatatype = require("./string")
EmailDatatype = require("./email")

###
@author Dimitrios C. Michalakos
###
class Datatypes

	@Boolean = BooleanDatatype
	@Number = NumberDatatype
	@String = StringDatatype
	@Date = DateDatatype
	@Time = TimeDatatype
	@Integer = IntegerDatatype
	@Email = EmailDatatype

	###
	Constructs and returns a new number datatype.
	@return {Datatypes.Number}
	###
	@number: -> new NumberDatatype()

	###
	Constructs and returns a new integer datatype.
	@return {Datatypes.Integer}
	###
	@integer: -> new IntegerDatatype()

	###
	Constructs and returns a new string datatype.
	@return {Datatypes.String}
	###
	@string: -> new StringDatatype()

	###
	Constructs and returns a new e-mail datatype.
	@return {Datatypes.Email}
	###
	@email: -> new EmailDatatype()

	###
	Constructs and returns a new boolean datatype.
	@return {Datatypes.Boolean}
	###
	@bool: -> new BooleanDatatype()

	###
	Constructs and returns a new date datatype.
	@return {Datatypes.Date}
	###
	@date: -> new DateDatatype()

	###
	Constructs and returns a new time datatype.
	@return {Datatypes.Time}
	###
	@time: -> new TimeDatatype()

module.exports = Datatypes
	