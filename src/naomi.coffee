MySqlConnector = require("./connectors/mysql")
EntitySet = require("./entity-set")
Attribute = require("./attribute")
async = require("async")

class Naomi

	@MYSQL: "MYSQL"
	@POSTGRE: "POSTGRE"
	
	@Attribute = Attribute

	###
	Contructs a new Naomi instance of the specified properties.
	@param {String} type the type of the database connector to use, e.g. "MYSQL".
	@param {Object} options key/value settings (optional).
	@throw {Error} if type is unspecified or invalid.
	###
	constructor: (type, options = {}) ->
		switch type
			when Naomi.MYSQL
				@_connector = new MySqlConnector(options)
			when Naomi.POSTGRE
				throw new Error("Postgre database not yet supported")
			else 
				throw new Error("Invalid or unsupported database engine")
		
		@schema = {}# store the database's entity sets (a.k.a. tables)
	
	###
	Creates and returns a new entity set of the specified properties.
	@param {String} name the name of the entity, must be unique.
	@param {Object} attributes the entity's attributes (optional).
	@param {Object} options key/value settings (optional).
	@return {EntitySet}
	@throw {Error} if EntitySet already exists in database.
	###
	extend: (name, attributes = {}, options = {}) ->
		if @schema.hasOwnProperty(name)
			throw new Error("Entity-set #{name} is already defined")
		
		entitySet = new EntitySet(@_connector, name, attributes, options)
		@schema[name] = entitySet# cache
		return entitySet

	###
	Acquires the specified entity set by name.
	@param {String} name the name of the entity, must be unique.
	@return {EntitySet, undefined}
	###
	get: (name) -> @schema[name]
		
	assosiate: -> null
	
	###
	Synchronizes the current naomi instance with the remote database.
	@note Makes sure the defined entity sets exist in the remote database, but doen't store any data in them.
	@param {Object} options key/value settings (optional).
	@param {Function} callback i.e. function(error, data).
	###
	sync: (options, callback = -> null) ->
		if typeof options is "function"
			callback = options

		tasks = []
		for own k, v of @schema
			tasks.push((callback) =>
				@_connector.create(k, v.attributes, v.options, callback)
			) 

		async.parallel(tasks, callback)
		return

module.exports = Naomi