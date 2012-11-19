MySqlPool = require("./mysql-pool")

class Naomi

	###*
	* Defines a list of supported database engines.
	###
	@MYSQL: 1
	@POSTGRE: 2

	###*
	* Maps port numbers to predefined database engines.
	###
	defaultPort = {}
	defaultPort[@MYSQL] = 3306

	###*
	* Defines a list of supported datatypes.
	###
	@STRING: 1
	@NUMBER: 2
	@BOOLEAN: 3
	@DATE: 4

	###*
	* Contructs and returns a new Naomi instance of the specified properties.
	* @param database {string} the name of the database (a.k.a. schema).
	* @param username {string} the name of the user to login to the database.
	* @param password {string} the password to login to the database.
	* @param o {Object=} optional settings.
	###
	constructor: (database, username, password, o = {}) ->
		if typeof database isnt "string"
			throw new Error("Invalid database name")
		if typeof username isnt "string"
			throw new Error("Invalid username")
		if typeof password isnt "string"
			throw new Error("Invalid password")
		if typeof o isnt "object"
			throw new Error("Invalid options, expecting an object")
		@database = database
		@username = username
		@password = password
		@engine = o.engine || Naomi.MYSQL
		@host = o.host || "localhost"
		@port = o.port || defaultPort[@engine]
		
#		#set connection pooling
		switch @engine
			when Naomi.MYSQL
				@pool = new MySqlPool(o)
			else
				throw new Error("Invalid or unknown database engine")
#		@pool = poolModule.Pool({
#			create : (callback) ->
#				switch
#			destroy: (conn) ->
#				
#			max: parseInt(o.maxConnections, 10) || 10
#			min: parseInt(o.minConnections) || 2
#			idleTimeoutMillis: parseInt(o.idleConnectionTimeout, 10) || 30000
#			log: true 
#		})
			
	extend: (name, attributes = {}, options = {}) ->
		return new Naomi.model(name, attributes, options)
		
	assosiate: ->
	
	sync: ->

module.exports = Naomi