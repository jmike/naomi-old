mansion = require("generic-pool")
mysql = require("mysql")
Attribute = require("../attribute")
NumberUtils = require("../utils/number")

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
		console.log sql
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
		unless Array.isArray(data) then data = [data]
	
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
	Creates a new entity set with the specified properties.
	@param {String} name the name of the entity set.
	@param {Object} attributes the entity set's attributes.
	@param {Object} options key/value settings.
	@option options {String} engine the entity set's internal engine, e.g. "MYISAM" or "InnoDB".
	@param {Function} callback i.e. function(error, data).
	###
	create: (name, attributes, options, callback) ->
		sql = "CREATE TABLE IF NOT EXISTS `#{name}`"
		params = []
		keys = (k for own k of attributes)

		sql += " ("
		for key, i in keys
			if i isnt 0
				sql += ", "
			sql += "`#{key}` "
			attr = attributes[key]

			if attr instanceof Attribute.Boolean# boolean
				sql += "TINYINT(1) UNSIGNED"

			else if attr instanceof Attribute.Number# number
				precision = attr.precision()
				scale = attr.scale()

				if scale is 0# integer
					min = attr.min()
					max = attr.max()

					if min >= 0# unsigned
						if max < 256
							sql += "TINYINT"
						else if max < 65536
							sql += "SMALLINT"
						else if max < 16777216
							sql += "MEDIUMINT"
						else if max < 4294967296 or typeof max is "undefined"
							sql += "INT"
						else
							sql += "BIGINT"
						sql += " UNSIGNED"

					else# signed
						if min >= -128 and max < 128
							sql += "TINYINT"
						else if min >= -32768 and max < 32768
							sql += "SMALLINT"
						else if min >= -8388608 and max < 8388608
							sql += "MEDIUMINT"
						else if min >= -2147483648 or typeof min is "undefined" and
						max < 2147483648 or typeof max is "undefined"
							sql += "INT"
						else
							sql += "BIGINT"

				else# float
					sql += "FLOAT"
					if typeof precision isnt "undefined" and typeof scale isnt "undefined"
						sql += "(#{precision}, #{scale})"
					if min >= 0# unsigned
						sql += " UNSIGNED"

			else if attr instanceof Attribute.String# String
				equals = attr.equals()

				if equals?# with predefined values
					if equals.length <= 64
						sql += "SET"
					else
						sql += "ENUM"
					sql += "("
					for value, i in equals
						if i isnt 0
							sql += ", "
						sql += "?"
						params.push(value)
					sql += ")"

				else# with free value
					exactLength = attr.length()
					maxLength = attr.maxLength() || 100

					if exactLength < 256
						sql += "CHAR(#{length})"
					else if maxLength < 256
						sql += "VARCHAR(#{maxLength})"
					else
						m = exactLength || maxLength
						if m < 65536
							sql += "TEXT"
						else if m < 16777216
							sql += "MEDIUMTEXT"
						else
							sql += "LONGTEXT"

			else if attr instanceof Attribute.Date# Date
				console.log "under contruction"

			if attr.nullable()
				sql += " NULL"
			else
				sql += " NOT NULL"

		sql += ")"

		engine = options.engine || "InnoDB"
		if engine?
			sql += " ENGINE = #{engine}"

		sql += ";"

		this.execute(sql, params, callback)
		return sql

#	fetch: ->
#		params = []
#		sql = "SELECT "
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
#		return sql
	
module.exports = MySqlConnector