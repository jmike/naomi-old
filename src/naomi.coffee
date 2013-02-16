MySqlConnector = require("./connectors/mysql")
Collection = require("./collection")
Attribute = require("./attribute")

class Naomi

	@MYSQL: "MYSQL"
	@POSTGRE: "POSTGRE"
	
	@Attribute = Attribute

	###
	Contructs a new Naomi instance of the specified properties.
	@param {String} type the type of the internal database connector, e.g. "MYSQL".
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