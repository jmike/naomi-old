MySqlConnectionPool = require("./mysql-connection-pool")
MySqlEntity = require("./mysql-entity")

class Naomi

	###*
	* Defines a list of supported database engines.
	###
	@MYSQL: "MYSQL"
	@POSTGRE: "POSTGRE"

	###*
	* Contructs a new Naomi instance of the specified properties.
	* @param database {string} the name of the database (a.k.a. schema).
	* @param username {string} the name of the user to login to the database.
	* @param password {string} the password to login to the database.
	* @param o {Object=} optional settings.
	###
	constructor: (database, username, password, options = {}) ->
		if typeof database isnt "string"
			throw new Error("Invalid database name")
		if typeof username isnt "string"
			throw new Error("Invalid username")
		if typeof password isnt "string"
			throw new Error("Invalid password")
		if typeof options isnt "object"
			throw new Error("Invalid options, expecting object, got #{typeof(options)}")
		@_engine = options.engine || Naomi.MYSQL
		@_entities = {}
		host = options.host || "localhost"
		port = parseInt(options.port, 10)
		minConnections = parseInt(options.maxConnections, 10)
		maxConnections = parseInt(options.maxConnections, 10)
		idleTimeout = parseInt(options.idleTimeout, 10)
		#create connection pool
		switch @_engine
			when Naomi.MYSQL
				@_pool = MySqlConnectionPool.create(
					database
					username
					password
					host
					port || 3306
					minConnections || 2
					maxConnections || 10
					idleTimeout || 30000
				)
			else 
				throw new Error("Invalid or unsupported database engine")
	
	###*
	* Creates and returns a new Entity.
	* @param name {string} the name of the entity, must be unique.
	* @param attributes {object=} the entity's attributes (optional).
	* @param options {object=} key/value settings (optional).
	* @return {Entity}
	###
	extend: (name, attributes = {}, options = {}) ->
		if @_entities[name]?
			throw new Error("Entity #{name} is already defined")
		switch @_engine
			when Naomi.MYSQL
				entity = new MySqlEntity(name, attributes, options)
			when Naomi.POSTGRE
				throw new Error("Postgre database not yet supported")
		@_entities[name] = entity
		return entity
		
	assosiate: ->
	
	sync: ->

module.exports = Naomi