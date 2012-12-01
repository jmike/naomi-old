Entity = require("./entity")

class MySqlEntity extends Entity

	constructor: (name, attributes = {}, options = {}) ->
		super(name, attributes, options)
		console.log super
	
	###*
	* Returns a set of records from this entity.
	* @param settings {Object|null} key/value pairs.
	* @param callback {function=} (optional).
	###
	get: (settings, callback) ->
	
	count: (settings, callback) ->
	
	set: (settings, callback) ->

	del: (settings, callback) ->
	
module.exports = MySqlEntity