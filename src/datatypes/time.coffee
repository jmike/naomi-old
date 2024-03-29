DateDatatype = require("./date")
moment = require("moment")
format = "HH:mm:ss.S"

###
@extend DateDatatype
@author Dimitrios C. Michalakos
###
class TimeDatatype extends DateDatatype

	###
	Constructs a new time datatype.
	@param {Object} properties key/value properties (optional).
    @option options {Boolean} nullable
    @option options {Date, String} min
    @option options {Date, String} max
    @option options {Array.<Date>} equals
    @option options {Array.<Date>} notEquals
	###
	constructor: (properties = {}) ->
		super(properties)

		# Hardcode the format property
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
				d = moment(value, format)
				return d.toDate()
		else
			return null

module.exports = TimeDatatype
