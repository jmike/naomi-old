MySqlConnector = require("./connectors/mysql")
EntitySet = require("./entity-set")
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
		
		# set a new object to store the database's entity sets (a.k.a. tables)
		@_entitySets = {}
	
	###
	Creates and returns a new EntitySet.
	@param name {String} the name of the entity, must be unique.
	@param attributes {Object} the entity's attributes (optional).
	@param options {Object} key/value settings (optional).
	@return {EntitySet}
	###
	extend: (name, attributes = {}, options = {}) ->
		if @_entitySets.hasOwnProperty(name)
			throw new Error("EntitySet #{name} is already defined")
		else
			e = new EntitySet(name, attributes, options)
			@_entitySets[name] = e
			return e
		
	assosiate: ->
	
	sync: ->

module.exports = Naomi