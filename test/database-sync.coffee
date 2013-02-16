assert = require("chai").assert
conn = require("./conn.json")
Naomi = require("../src/naomi")
Attribute = Naomi.Attribute

describe("Database sync", ->

	this.timeout(10000)
	
	it("should work flawless on MySql", (done) ->
		db = new Naomi("MYSQL", conn.MYSQL)
		User = db.extend("user", {
			"name": Attribute.integer().max(100)
			"email": Attribute.bool()
		}, {
			engine: Naomi.MYISAM
		})
		db.sync((error, data) ->
			assert.strictEqual(error, null)
			done()
		)
	)

)