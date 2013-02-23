DateDatatype = require("./date")
moment = require("moment")
format = "HH:mm:ss.S"

###
@extend DateDatatype
@author Dimitrios C. Michalakos
###
class EmailDatatype extends DateDatatype

	###
	Constructs a new email datatype.
	@param {Object} properties key/value properties (optional).
	###
	constructor: (properties = {}) ->
		super(properties)
		Object.defineProperty(@properties, "format", {
			value: format
			writable: false
			enumerable: true
			configurable: false
		})
	
	###
	Parses the supplied value and returns Date or null.
	@param {*} value
	@return {Date, null}
	###
	@parse: (value) ->
		if value?
			if value instanceof Date
				return value
			else
				x = moment(value, format)
				return x.toDate()
		else
			return null

module.exports = EmailDatatype
