mansion = require("generic-pool")
mysql = require("mysql")
Datatypes = require("../datatypes")
NumberUtils = require("../utils/number")

###
@author Dimitrios C. Michalakos
###
class Connector

	###
	Constructs a new mysql connector of the designated properties.
	@param {Object} options key/value properties.
	@option options {String} database the name of the database (a.k.a. schema) to connect to.
	@option options {String} username the name of the user to login to the database.
	@option options {String} password the password of the user to login to the database.
	@option options {String} host the ip adress or hostname of the database (optional), defaults to "localhost".
	@option options {Number} port the port number of the database (optional), defaults to 3306.
	@option options {Number} minConnections the minimum number of connections to keep in the pool at any given time (optional), defaults to 2.
	@option options {Number} maxConnections the maximum number of connections to create at any given time (optional), defaults to 10.
	@option options {Number} idleTimeout time, in milliseconds, a connection can go unused before being destroyed (optional), defaults to 30000.
	@throw {Error} if options is unspecified or invalid.
	###
	constructor: (options) ->
		# Make sure options is valid
		if typeof options isnt "object"
			throw new Error("Invalid connector's options - expected Object, got #{typeof options}")

		# Extract connector properties from options
		database = options.database
		username = options.username
		password = options.password
		host = options.host || "localhost"
		port = options.port || 3306
		minConnections = options.minConnections || 2
		maxConnections = options.maxConnections || 10
		idleTimeout = options.maxConnections || 30000
		
		# Make sure connector properties are valid
		if typeof database isnt "string"
			throw new Error("Invalid database name: expected string, got #{typeof database}")
		if typeof username isnt "string"
			throw new Error("Invalid username: expected string, got #{typeof username}")
		if typeof password isnt "string"
			throw new Error("Invalid password: expected string, got #{typeof password}")

		# Create connection pool
		@pool = mansion.Pool({
			
			###
			Creates a new connection.
			@param {Function} callback i.e. function(error, connection).
			###
			create: (callback) ->
				client = mysql.createConnection({
					database
					user: username
					password
					host
					port
				})
				client.connect()
				callback(null, client)

			###
			Destroys the supplied connection.
			###
			destroy: (client) -> client.end()
			
			# Set pool's optional properties.
			min: minConnections
			max: maxConnections
			idleTimeoutMillis: idleTimeout
			log: false

		})
		return
	
	###
	Executes the given parameterized SQL statement.
	@param {String} sql the parameterized SQL statement.
	@param {Array} params an array of parameters.
	@param {Function} callback i.e. function(error, data).
	###
	execute: (sql, params, callback = -> null) ->
		@pool.acquire((error, client) =>
			if error?
				callback(error)
			else
				client.query(sql, params, (error, data) =>
					@pool.release(client)
					callback(error, data)
				)
		)
		return

	###
	Generates and returns a parameterized SQL where clause based on the supplied filter AST.
	@param {Object} ast the filter abstract syntax tree.
	@param {String} entity the entity identifier in the filter object (optional), defaults to "entity".
	@return {Object}
	###
	filter: (ast, entity = "entity") ->
		sql = ""
		params = []

		switch ast.type
			when "Program"
				for e in ast.body
					obj = this._where(e)
					sql += obj.sql
					params = params.concat(obj.params)
			when "ExpressionStatement"
				sql += this._where(ast.expression)
			when "AssignmentExpression", "BinaryExpression"
				sql += "#{this._where(ast.left)} #{ast.operator} #{_where(ast.right)}"
			when "LogicalExpression"
				sql += "(#{_where(ast.left)} #{ast.operator} #{_where(ast.right)})"
			when "Identifier"
				sql += ast.name
			when "Literal"	
				sql += ast.value
			else
				throw Error("Unsupported javascript clause: #{ast.type}")

		return {sql, params}
	
	###
	Adds the supplied data to the designated entity set.
	@param {String} name the name of the table.
	@param {Object} attributes an object describing the table's fields.
	@param {Object|Array<Object>} data
	@param {Boolean} duplicateUpdate a boolean flag indicating whether duplicate records should be updated.
	@param {Function} callback i.e. function(error, data).
	###
	add: (name, attributes, data, duplicateUpdate, callback) ->
		sql = "INSERT INTO `#{name}`"
		params = []
		keys = (k for own k of attributes)
		
		unless Array.isArray(data)
			data = [data]
	
		sql += " ("
		for key, i in keys
			if i isnt 0
				sql += ", "
			sql += "`#{key}`"
		sql += ")"
		
		sql += " VALUES "
		for values, i in data
			if i isnt 0
				sql += ", "
			sql += "("
			for key, j in keys
				if j isnt 0
					sql += ", "
				sql += "?"
				attr = attributes[key]
				value = values[key]
				params.push(attr.parse(value, false))
			sql += ")"
		
		if duplicateUpdate
			sql += " ON DUPLICATE KEY UPDATE "
			for key, i in keys
				if i isnt 0
					sql += ", "
				sql += "`#{key}` = VALUES(`#{key}`)"
		
		sql += ";"
		
		this.execute(sql, params, callback)
		return sql

	###
	Fetches the specified entities from database.
	@param {String} name the name of the entity set.
	@param {Object} attributes the attributes of the entity set.
	@param {Object} query maps, filters, sorts and limits the returned entities.
	@param {Object} options key/value settings.
	@param {Function} callback i.e. function(error, data).
	###
	fetch: (name, attributes, query, options, callback) ->
		sql = "SELECT "
		params = []
		
		if query.filter
			console.log this._where(query.filter)
#		if query.show?
#			for x, i in query.show
#				if i isnt 0 then sql += ", "
#				sql += "`#{x.key}`"
#				if x.alias?
#					sql += " AS '{x.alias}'"
#		else
#			sql += "*"
#		sql += " FROM `#{this.name}`"
#		sql += ";"
		return sql

module.exports = Connector