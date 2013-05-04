StringDatatype = require("./string")
re = /^(?:[\w\!\#\$\%\&\'\*\+\-\/\=\?\^\`\{\|\}\~]+\.)*[\w\!\#\$\%\&\'\*\+\-\/\=\?\^\`\{\|\}\~]+@(?:(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9\-](?!\.)){0,61}[a-zA-Z0-9]?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9\-](?!$)){0,61}[a-zA-Z0-9]?)|(?:\[(?:(?:[01]?\d{1,2}|2[0-4]\d|25[0-5])\.){3}(?:[01]?\d{1,2}|2[0-4]\d|25[0-5])\]))$/

###
@extend StringDatatype
@author Dimitrios C. Michalakos
###
class EmailDatatype extends StringDatatype

	###
	Constructs a new email datatype.
	@param {Object} properties key/value properties (optional).
	###
	constructor: (properties = {}) ->
		super(properties)

		# Hardcode the regex property
		Object.defineProperty(@properties, "regex", {
			value: re
			writable: false
			enumerable: true
			configurable: false
		})
	
	###
	Parses the supplied value and returns an email string or null.
	@param {*} value
	@return {String, null}
	###
	@parse: (value) ->
		if typeof value is "string" and re.test(value)
			return value
		else
			return null

module.exports = EmailDatatype
