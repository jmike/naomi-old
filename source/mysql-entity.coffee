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
	get: (query, callback) ->
		params = []
		sql = "SELECT "
		if query.show?
			for x, i in query.show
				if i isnt 0 then sql += ", "
				sql += "`#{x.key}`"
				if x.alias?
					sql += " AS '{x.alias}'"
		else
			sql += "*"
		sql += " FROM `#{this.name}`"
		sql += ";"
		return sql
	
	count: (settings, callback) ->
	
	set: (settings, callback) ->

	del: (settings, callback) ->
	
module.exports = MySqlEntity