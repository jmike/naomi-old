mansion = require("generic-pool")
mysql = require("mysql")

###
@author Dimitrios C. Michalakos
###
class MySqlConnector

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
	###
	constructor: (options) ->
		# Make sure options is valid
		if typeof options isnt "object"
			throw new Error("Invalid connector's options - expected Object, got #{typeof options}")
		
		# Extract connector properties
		database = options.database
		username = options.username
		password = options.password
		host = options.host || "localhost"
		port = options.port || 3306
		minConnections = options.minConnections || 2
		maxConnections = options.maxConnections || 10
		idleTimeout = options.maxConnections || 30000
		
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
	Adds the specified data to the designated table.
	@param {Collection} collection the name of the table.
	@param {Object} attributes an object describing the table's fields.
	@param {Object|Array} data
	@param {Boolean} updateDuplicate a boolean flag indicating whether duplicate records should be updated.
	@param {Function} callback i.e. function(error, data).
	###
	add: (collection, attributes, data, updateDuplicate, callback) ->
		sql = "INSERT INTO `#{collection}`"
		params = []
		fields = name for own name of attributes
		unless Array.isArray(data) then data = [data]
	
		sql += " ("
		for name, i in fields
			if i isnt 0
				sql += ", "
			sql += "`#{name}`"
		sql += ")"
		
		sql += " VALUES "
		for values, i in data
			if i isnt 0
				sql += ", "
			sql += "("
			for name, j in fields
				if i isnt 0
					sql += ", "
				sql += "?"
				params.push(attributes[name].parse(data[name]))
			sql += ")"
		
		if updateDuplicate
			sql += " ON DUPLICATE KEY UPDATE "
			for name, i in fields
				if i isnt 0
					sql += ", "
				sql += "`#{name}` = VALUES(`#{name}`)"
			sql += ")"
		
		sql += ";"
		
		console.log sql
		this.execute(sql, params, callback)
		return sql
	
module.exports = MySqlConnector