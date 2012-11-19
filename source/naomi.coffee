class Naomi

	###*
	* Defines a list of supported database engines.
	###
	@MYSQL: 1
	@POSTGRE: 2

	###*
	* Maps port numbers to predefined database engines.
	###
	defaultPort = {
		@MYSQL: 3306
	}

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
	* @param options {Object=} optional settings.
	###
	constructor: (database, username, password, options = {}) ->
		if typeof database isnt "string"
			throw new Error("Invalid database name")
		if typeof username isnt "string"
			throw new Error("Invalid username")
		if typeof password isnt "string"
			throw new Error("Invalid password")
		@database = database
		@username = username
		@password = password
		@engine = options.engine || @MYSQL
		@host = options.host || "localhost"
		@port = options.host || "localhost"
			
	extend: (name, attributes = {}, options = {}) ->
		return new Naomi.model(name, attributes, options)
		
	assosiate: ->
	
	sync: ->

module.exports = Naomi