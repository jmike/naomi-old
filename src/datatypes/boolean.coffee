AbstractDatatype = require("./abstract")

###
@extend AbstractDatatype
@author Dimitrios C. Michalakos
###
class BooleanDatatype extends AbstractDatatype

	###
	Constructs a new boolean datatype.
	@param {Object} options key/value properties (optional).
	###
	constructor: (options = {}) ->
		super(options)

	###
	Parses the supplied value and returns boolean or null.
	@param {*} value
	@return {Boolean, null}
	###	
	@parse: (value) ->
		if value?
			switch typeof value
				when "boolean"
					return value
				when "string", "number"
					return /^(true|1)$/i.test(value) or value is 1
				else
					return Boolean(value)
		else# null or undefined
			return null

	###
	Throws an error if the specified value is invalid.
	@param {*} value
	@param {Boolean} parse indicates whether the specified value should be parsed before being validated, defaults to true.
	@throw {Error} if value is invalid.
	###
	validate: (value, parse = true) ->
		if parse
			value = BooleanDatatype.parse(value)
		super(value)
		return

	###
	Parses the supplied value and returns boolean or null.
	@param {*} value
	@param {Boolean} validate indicates whether the result should be validated before being returned, defaults to true.
	@return {Boolean, null}
	###	
	parse: (value, validate = true) ->
		value = BooleanDatatype.parse(value)
		if validate
			try
				this.validate(value, false)
			catch error
				throw error
		return value

module.exports = BooleanDatatype