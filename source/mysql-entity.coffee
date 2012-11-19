Entity = require("./entity")

class MySqlEntity extends Entity

	constructor: (name, attributes = {}, options = {}) ->
	
	###*
	* Returns a set of records from this entity.
	* @param settings {Object|null} key/value pairs.
	* @param callback {function=} (optional).
	###
	get: (settings, callback) ->
	
	count: (settings, callback) ->
	
	set: (settings, callback) ->

	del: (settings, callback) ->
	
	isValid: (attribute, value) ->
	
module.exports = MySqlEntity