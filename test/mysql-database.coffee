assert = require("chai").assert
conn = require("./conn.json")
Naomi = require("../src/naomi")
Attribute = Naomi.Attribute

describe("MySql database", ->

	this.timeout(10000)
	
	db = new Naomi("MYSQL", conn.MYSQL)
	User = db.extend("user", {
		"name": Attribute.string().maxLength(100)
		"gender": Attribute.string().equals("MALE", "FEMALE")
		"age": Attribute.integer().max(133)
		"email": Attribute.email()
	}, {
		engine: Naomi.MYISAM
	})
	
	it("should sync fine with remote database", (done) ->
		db.sync((error, data) ->
			assert.strictEqual(error, null)
			done()
		)
	)

)