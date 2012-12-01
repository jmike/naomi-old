mansion = require("generic-pool")
mysql = require("mysql")

###*
* Creates and returns a connection pool of the designated properties.
* @param database {string} the name of the database (a.k.a. schema) to connect to.
* @param user {string} the name of the user to login to the database.
* @param password {string} the password of the user to login to the database.
* @param host {string} the ip adress or hostname of the database.
* @param port {number} the port number of the database.
* @param minConnections {number} the minimum number of connections to keep in pool at any given time.
* @param maxConnections {number} the maximum number of connections to create at any given time.
* @param idleTimeout {number} the maximum time, in milliseconds, a connection can go unused before being destroyed.
###
create = (
	database
	user
	password
	host
	port
	minConnections
	maxConnections
	idleTimeout
) ->
	return mansion.Pool({
		create : (callback) ->
			client = mysql.createConnection({
				database
				user
				password
				host
				port
			})
			client.connect()
			callback(null, client)
		destroy: (client) ->
			client.end()
		min: minConnections
		max: maxConnections
		idleTimeoutMillis: idleTimeout
		log: false
	})

exports.create = create