MySqlConnector = require("./connectors/mysql")
Collection = require("./collection")
Attribute = require("./attribute")

class Naomi

	@MYSQL: "MYSQL"
	@POSTGRE: "POSTGRE"
	
	@Attribute = Attribute

	###
	Contructs a new Naomi instance of the specified properties.
	@param {String} database the name of the database (a.k.a. schema).
	@param {String} username the name of the user to login to the database.
	@param {String} password the password to login to the database.
	@param {Object} options key/value settings.
	@throw {Error}
	###
	constructor: (database, username, password, options = {}) ->
		if typeof database isnt "string"
			throw new Error("Invalid database name: expected string, got #{typeof database}")
		if typeof username isnt "string"
			throw new Error("Invalid username: expected string, got #{typeof username}")
		if typeof password isnt "string"
			throw new Error("Invalid password: expected string, got #{typeof password}")
		if typeof options isnt "object"
			throw new Error("Invalid options: expected object, got #{typeof(options)}")
		engine = options.engine || Naomi.MYSQL

		# set the database's connector
		switch engine
			when Naomi.MYSQL
				@_connector = new MySqlConnector(options)
			when Naomi.POSTGRE
				throw new Error("Postgre database not yet supported")
			else 
				throw new Error("Invalid or unsupported database engine")
		
		# set a new object to store the database's tables (a.k.a. collections)
		@_collections = {}
	
	###
	Creates and returns a new Collection.
	@param name {String} the name of the entity, must be unique.
	@param attributes {Object} the entity's attributes (optional).
	@param options {Object} key/value settings (optional).
	@return {Collection}
	###
	extend: (name, attributes = {}, options = {}) ->
		if @_collections.hasOwnProperty(name)
			throw new Error("Collection #{name} is already defined")
		else
			collection = new Collection(name, attributes, options)
			@_collections[name] = collection
			return collection
		
	assosiate: ->
	
	sync: ->

module.exports = Naomi