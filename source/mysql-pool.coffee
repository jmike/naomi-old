poolModule = require("generic-pool")
mysql = require("mysql")

class MySqlPool

	###*
	* Constructs a new connection pool of the specified properties.
	* @param o {object=} a set of key/value properties (optional).
	###
	constructor: (o = {}) ->
		return poolModule.Pool({
			create : (callback) ->
				client = mysql.createConnection({
					database: o.database
					user: o.username
					password: o.password
					host: o.host
					port: o.port
				})
				client.connect()
				callback(null, client)
			destroy: (client) ->
				client.end()
			max: parseInt(o.maxConnections, 10) || 10
			min: parseInt(o.minConnections) || 2
			idleTimeoutMillis: parseInt(o.idleConnectionTimeout, 10) || 30000
			log: false
		})

module.exports = MySqlPool