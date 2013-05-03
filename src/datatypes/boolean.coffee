AbstractDatatype = require("./abstract")

###
@extend AbstractDatatype
@author Dimitrios C. Michalakos
###
class BooleanDatatype extends AbstractDatatype

	###
	Constructs a new boolean datatype.
	@param {Object} properties key/value properties (optional).
    @option options {Boolean} nullable
	###
	constructor: (properties = {}) ->
		super(properties)

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
				when "string"
					return /^(true|1)$/i.test(value) or value is 1
				when "number"
					return value is 1
				else
					return Boolean(value)
		else# null or undefined
			return null

	###
	Throws an error if the specified value cannot be assigned to the datatype.
	@param {*} value
	@param {Boolean} parse indicates whether the specified value should be parsed before being validated, defaults to true.
	@throw {Error} if value is invalid.
	###
	validate: (value, parse = true) ->
		if parse
			value = BooleanDatatype.parse(value)

		super(value)

	###
	Parses the supplied value and returns boolean or null.
	@param {*} value
	@return {Boolean, null}
    @throw {Error} if value is invalid.
	###	
	parse: (value) ->
		value = BooleanDatatype.parse(value)

		try
			this.validate(value, false)
		catch error
			throw error

		return value

module.exports = BooleanDatatype