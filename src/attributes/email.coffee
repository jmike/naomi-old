StringAttribute = require("./string")

###
@extend StringAttribute
@author Dimitrios C. Michalakos
###
class EmailAttribute extends StringAttribute

	###
	Constructs a new email attribute.
	@param {Object} options key/value properties (optional).
	###
	constructor: (options = {}) ->
		super(options)
		Object.defineProperty(@options, "regex", {
			value: /^(?:[\w\!\#\$\%\&\'\*\+\-\/\=\?\^\`\{\|\}\~]+\.)*[\w\!\#\$\%\&\'\*\+\-\/\=\?\^\`\{\|\}\~]+@(?:(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9\-](?!\.)){0,61}[a-zA-Z0-9]?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9\-](?!$)){0,61}[a-zA-Z0-9]?)|(?:\[(?:(?:[01]?\d{1,2}|2[0-4]\d|25[0-5])\.){3}(?:[01]?\d{1,2}|2[0-4]\d|25[0-5])\]))$/
			writable: false
			enumerable: true
			configurable: false
		})

module.exports = EmailAttribute
