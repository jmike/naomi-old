class Naomi

	###*
	* Defines a list of supported datatypes.
	###
	@STRING: 1
	@NUMBER: 2
	@BOOLEAN: 3
	@DATE: 4

	###*
	* Contructs and returns a new Naomi instance of the specified properties.
	###
	constructor: (database, username, password, options = {}) ->
	
	extend: (name, attributes = {}, options = {}) ->
		return new Naomi.model(name, attributes, options)
	
class Naomi.Model

	constructor: (name, attributes = {}, options = {}) ->
	
	###*
	* Returns a set of records from model.
	* @param settings {Object|null} key/value pairs.
	* @param callback {function=} (optional).
	###
	get: (settings, callback) ->
	
	count: (settings, callback) ->
	
	set: (settings, callback) ->

	del: (settings, callback) ->
	
	isValid: (attribute, value) ->

module.exports = Naomi